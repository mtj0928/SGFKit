public final class Node<Game: SGFKit.Game> {
    public let id: Int
    public weak var parent: Node<Game>?
    private(set) var properties: [Property]
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

    public init(identifier: String, values: [Compose]) {
        self.identifier = identifier
        self.values = values
    }
}

public enum Compose: Hashable, Equatable, Sendable {
    case single(String?)
    case compose(String?, String?)

    public var first: String? {
        switch self {
        case .single(let string), .compose(let string, _): return string
        }
    }

    public var second: String? {
        switch self {
        case .single: return nil
        case .compose(_, let second): return second
        }
    }
}
