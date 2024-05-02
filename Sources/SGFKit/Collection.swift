public struct Collection<Game: SGFKit.Game>  {
    public var nodes: [Node<Game>]

    public init(nodes: [Node<Game>]) {
        self.nodes = nodes
    }

    public init(_ collection: NonTerminalSymbols.Collection) {
        let idPublisher = IDPublisher()
        // SGF can have multiple root nodes.
        let nodes: [Node<Game>]  = collection.gameTrees
            .compactMap { Self.rootNode(gameTree: $0, idPublisher: idPublisher) }
        self.init(nodes: nodes)
    }
}

// MARK: - Make

extension Collection {

    private static func rootNode(gameTree: NonTerminalSymbols.GameTree, idPublisher: IDPublisher) -> Node<Game>? {
        let nodes: [Node<Game>] = gameTree.sequence.nodes.map { node(node: $0, idPublisher: idPublisher) }
        for index in nodes.indices {
            if index != nodes.endIndex - 1 {
                nodes[index + 1].parent = nodes[index]
                nodes[index].children.append(nodes[index + 1])
            }
        }

        let children: [Node<Game>] = gameTree.gameTrees.compactMap { rootNode(gameTree: $0, idPublisher: idPublisher) }

        nodes.last?.children = children
        children.forEach { child in
            child.parent = nodes.last
        }
        return nodes.first
    }

    private static func node(node: NonTerminalSymbols.Node, idPublisher: IDPublisher) -> Node<Game> {
        let properties = node.properties.map { property(property: $0) }
        return Node(id: idPublisher.publish(), properties: properties)
    }

    private static func property(property: NonTerminalSymbols.Property) -> Property {
        let composes = property.values.map(\.type).map { compose(compose: $0) }
        return Property(identifier: property.identifier.letters, values: composes)
    }

    private static func compose(compose: NonTerminalSymbols.CValueType) -> Compose {
        switch compose {
        case .single(let value):
            return .single(value?.value)
        case .compose(let first, let second):
            return .compose(first?.value, second?.value)
        }
    }
}

private final class IDPublisher {
    private var currentID = 0

    func publish() -> Int {
        let result = currentID
        currentID += 1
        return result
    }
}

// MARK: - Convert to SGF

extension Collection {
    func convertToSGF() -> String {
        convertToNonTerminalSymbol().convertToSGF()
    }

    func convertToNonTerminalSymbol() -> NonTerminalSymbols.Collection {
        let gameTrees = nodes.map { gameTree(from: $0) }
        return NonTerminalSymbols.Collection(gameTrees: gameTrees)
    }

    private func gameTree(from node: Node<Game>) -> NonTerminalSymbols.GameTree {
        var sequenceNodes: [NonTerminalSymbols.Node] = []
        var currentNode = node

        while true {
            let node = convertToNode(from: currentNode)
            sequenceNodes.append(node)
            if currentNode.children.isEmpty {
                return NonTerminalSymbols.GameTree(
                    sequence: NonTerminalSymbols.Sequence(nodes: sequenceNodes),
                    gameTrees: []
                )
            }
            else if currentNode.children.count == 1 {
                currentNode = currentNode.children[0]
            } else {
                break
            }
        }

        let gameTrees = currentNode.children.map { gameTree(from: $0) }

        return NonTerminalSymbols.GameTree(
            sequence: NonTerminalSymbols.Sequence(nodes: sequenceNodes),
            gameTrees: gameTrees
        )
    }

    private func convertToNode(from node: Node<Game>) -> NonTerminalSymbols.Node {
        let properties = node.properties.map { property in
            convertToProperty(from: property)
        }

        return NonTerminalSymbols.Node(properties: properties)
    }

    private func convertToProperty(from property: Property) -> NonTerminalSymbols.Property {
        let values = property.values.map { value in convertToPropValue(from: value) }
        return NonTerminalSymbols.Property(
            identifier: NonTerminalSymbols.PropIdent(letters: property.identifier),
            values: values
        )
    }

    private func convertToPropValue(from value: Compose) -> NonTerminalSymbols.PropValue {
        switch value {
        case .single(let value):
            return NonTerminalSymbols.PropValue(type: .single(value.flatMap({ NonTerminalSymbols.ValueType($0) })))
        case .compose(let valueA, let valueB):
            return NonTerminalSymbols.PropValue(type: .compose(
                valueA.map { NonTerminalSymbols.ValueType($0) },
                valueB.map { NonTerminalSymbols.ValueType($0) }
            ))
        }
    }
}
