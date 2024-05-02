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
