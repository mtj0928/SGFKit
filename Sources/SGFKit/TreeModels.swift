public enum TreeModels {
    public final class Collection<Game: SGFKit.Game>  {
        public var nodes: [Node<Game>]

        public init(nodes: [Node<Game>]) {
            self.nodes = nodes
        }
    }

    public final class Node<Game: SGFKit.Game> {
        public let id: Int
        public weak var parent: Node<Game>?
        private var properties: [Property]
        public var children: [Node<Game>] = []

        init(id: Int, properties: [Property]) {
            self.id = id
            self.properties = properties
        }

        public func propertyValue<Value: PropertyValue>(of definition: PropertyDefinition<Game, Value>) -> Value? {
            if let property = properties.first(where: { $0.identifier == definition.name }) {
                return Value(property)
            }

            if definition.inherit {
                return parent?.propertyValue(of: definition)
            }

            return nil
        }

        public func has(of definition: PropertyDefinition<Game, some PropertyValue>) -> Bool {
            return properties.contains(where: { $0.identifier == definition.name })
        }
    }

    public struct Property: Hashable, Equatable, Sendable {
        public var identifier: String
        public var values: [Compose]
    }

    public enum Compose: Hashable, Equatable, Sendable {
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
        let idPublisher = IDPublisher()
        // SGF can have multiple root nodes.
        let nodes: [Node<Game>]  = collection.gameTrees.compactMap { rootNode(gameTree: $0, idPublisher: idPublisher) }
        return Collection(nodes: nodes)
    }

    private static func rootNode<Game: SGFKit.Game>(gameTree: NonTerminalSymbols.GameTree, idPublisher: IDPublisher) -> Node<Game>? {
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

    private static func node<Game: SGFKit.Game>(node: NonTerminalSymbols.Node, idPublisher: IDPublisher) -> Node<Game> {
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

    private final class IDPublisher {
        private var currentID = 0

        func publish() -> Int {
            let result = currentID
            currentID += 1
            return result
        }
    }
}
