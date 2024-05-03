public protocol NodeDelegate<Game>: AnyObject {
    associatedtype Game: SGFKit.Game

    /// A unique number for the node in the collection.
    /// The numbering rule follows [the official documents rule](https://www.red-bean.com/sgf/sgf4.html#1)
    /// When the number is not fixed, `nil` returns.
    /// If the class is not ``Node`` like ``Collection``,  `-1` is returned.
    var number: Int? { get }

    func node(treeStructureDidUpdated: Int?)
    func propertyValue<Value: PropertyValue>(of definition: PropertyDefinition<Game, Value>) -> Value?
}

public final class Node<Game: SGFKit.Game>: NodeDelegate {
    public internal(set) var number: Int?
    public internal(set) weak var parent: (any NodeDelegate<Game>)?

    public var children: [Node<Game>] = [] {
        didSet { parent?.node(treeStructureDidUpdated: number) }
    }
    private(set) var properties: [Property]

    public init(properties: [Property]) {
        self.number = nil
        self.properties = properties
    }

    init(number: Int, properties: [Property]) {
        self.number = number
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

    public func has(_ definition: PropertyDefinition<Game, some PropertyValue>) -> Bool {
        properties.contains(where: { $0.identifier == definition.name })
    }

    public func addProperty<Value: PropertyValue>(_ value: Value, to definition: PropertyDefinition<Game, Value>) {
        if has(definition) {
            properties = properties.map {
                $0.identifier == definition.name ? Property(identifier: $0.identifier, values: value.convertToComposes()) : $0
            }
        }
        else {
            properties.append(Property(identifier: definition.name, values: value.convertToComposes()))
        }
    }

    public func removeProperty<Value: PropertyValue>(of definition: PropertyDefinition<Game, Value>) {
        properties = properties.filter { property in property.identifier != definition.name }
    }

    public func node(treeStructureDidUpdated index: Int?) {
        parent?.node(treeStructureDidUpdated: index)
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
