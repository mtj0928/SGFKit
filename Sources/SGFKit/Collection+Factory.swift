extension Collection {
    public convenience init(_ collection: NonTerminalSymbols.Collection) {
        let nodes: [Node<Game>] = collection.gameTrees.compactMap { Self.rootNode(gameTree: $0) }
        self.init(nodes: nodes)
    }

    private static func rootNode(gameTree: NonTerminalSymbols.GameTree) -> Node<Game>? {
        let nodes: [Node<Game>] = gameTree.sequence.nodes.map { node(node: $0) }
        for index in nodes.indices {
            if index != nodes.endIndex - 1 {
                nodes[index].children.append(nodes[index + 1])
            }
        }

        let children: [Node<Game>] = gameTree.gameTrees.compactMap { rootNode(gameTree: $0) }

        nodes.last?.children = children
        children.forEach { child in
            child.parent = nodes.last
        }
        return nodes.first
    }

    private static func node(node: NonTerminalSymbols.Node) -> Node<Game> {
        let properties = node.properties.map { property(property: $0) }
        return Node(properties: properties)
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
