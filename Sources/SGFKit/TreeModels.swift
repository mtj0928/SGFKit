public enum TreeModels {
    public struct Collection<Game: SGFKit.Game>  {
        public var gameTrees: [GameTree<Game>]
    }

    public struct GameTree<Game: SGFKit.Game>  {
        public var nodes: [Node<Game>]
        public var gameTrees: [GameTree<Game>]
    }

    public struct Node<Game: SGFKit.Game> {
        public var properties: [Property]

        public func propertyValue<Value: PropertyValue>(of definition: PropertyDefinition<Game, Value>) -> Value? {
            guard let property = properties.first(where: { $0.identifier == definition.name }) else { return nil }
            return Value(property)
        }

        public func has(of definition: PropertyDefinition<Game, some PropertyValue>) -> Bool {
            return properties.contains(where: { $0.identifier == definition.name })
        }
    }

    public struct Property {
        public var identifier: String
        public var values: [Compose]
    }

    public enum Compose {
        case single(String?)
        case compose(String?, String?)

        var first: String? {
            switch self {
            case .single(let string), .compose(let string, _): return string
            }
        }
    }
}

extension TreeModels {

    public static func simplify<Game: SGFKit.Game>(collection: NonTerminalSymbols.Collection) -> Collection<Game> {
        let gameTrees: [GameTree<Game>] = collection.gameTrees.map { gameTree(gameTree: $0) }
        return Collection(gameTrees: gameTrees)
    }

    private static func gameTree<Game: SGFKit.Game>(gameTree: NonTerminalSymbols.GameTree) -> GameTree<Game> {
        let nodes: [Node<Game>] = gameTree.sequence.nodes.map { node(node: $0) }
        let gameTrees: [GameTree<Game>] = gameTree.gameTrees.map { Self.gameTree(gameTree: $0) }
        return GameTree(nodes: nodes, gameTrees: gameTrees)
    }

    private static func node<Game: SGFKit.Game>(node: NonTerminalSymbols.Node) -> Node<Game> {
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


