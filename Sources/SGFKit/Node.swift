protocol NodeProtocol<Game>: AnyObject {
    associatedtype Game: SGFKit.Game

    var number: Int? { get }

    func node(treeStructureDidUpdated: Int?)
    func propertyValue<Value: PropertyValue>(of definition: PropertyDefinition<Game, Value>) -> Value?
}

/// A node object for SGF.
public final class Node<Game: SGFKit.Game> {
    /// A unique number for the node in the collection.
    ///
    /// The numbering rule follows [the official documents rule](https://www.red-bean.com/sgf/sgf4.html#1)
    /// When the number is not fixed, `nil` returns.
    ///
    /// - SeeAlso: [1. SGF basics in the official documents](https://www.red-bean.com/sgf/sgf4.html#1)
    public internal(set) var number: Int?

    /// The parent node of this node.
    public var parentNode: (Node<Game>)? { parent as? Node<Game> }

    weak var parent: (any NodeProtocol<Game>)?

    /// The children of the node.
    ///
    /// The first node is the main line of play, the other lines are variations.
    ///
    /// - SeeAlso: [1. SGF basics in the official documents](https://www.red-bean.com/sgf/sgf4.html#1)
    public var children: [Node<Game>] = [] {
        didSet { parent?.node(treeStructureDidUpdated: number) }
    }

    /// The property of the node.
    /// Use `propertyValue` or `removeValue` for read and write the properties.
    public private(set) var properties: [Property]
    
    /// Makes the node.
    /// - Parameter properties: The property of the node.
    public init(properties: [Property] = []) {
        self.number = nil
        self.properties = properties
    }

    init(number: Int, properties: [Property]) {
        self.number = number
        self.properties = properties
    }
    /// Get the value corresponding to the given property definition.
    ///
    /// `nil` is returned when the node doesn't have the property.
    public func propertyValue<Value: PropertyValue>(of definition: PropertyDefinition<Game, Value>) -> Value? {
        if let property = properties.first(where: { $0.identifier == definition.name }) {
            return Value(property.values)
        }

        if definition.inherit {
            return parent?.propertyValue(of: definition)
        }

        return nil
    }
    
    /// Checks whether the node has the property or not.
    public func has(_ definition: PropertyDefinition<Game, some PropertyValue>) -> Bool {
        properties.contains(where: { $0.identifier == definition.name })
    }

    /// Adds the property to the node.
    /// When the node has already the property, the value is updated.
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

    /// Removes the property from the node.
    public func removeProperty<Value: PropertyValue>(of definition: PropertyDefinition<Game, Value>) {
        properties = properties.filter { property in property.identifier != definition.name }
    }

    /// Makes the copy of the node.
    ///
    /// > Note: The returned node doesn't have `parent` and its `number` is not updated.
    public func copy() -> Node<Game> {
        let properties = self.properties

        let node = Node<Game>(properties: properties)

        let children = self.children.map { $0.copy() }
        children.forEach { child in
            child.parent = node
        }
        node.children = children
        return node
    }
}

extension Node: NodeProtocol {
    func node(treeStructureDidUpdated index: Int?) {
        parent?.node(treeStructureDidUpdated: index)
    }
}

/// A struct indicating a raw property of a node.
public struct Property: Hashable, Equatable, Sendable {

    /// An identifier of the node.
    public var identifier: String

    /// An array of the values.
    public var values: [Compose]
    
    /// Creates a Property
    /// - Parameters:
    ///   - identifier: An identifier of the node.
    ///   - values: An array of the values.
    public init(identifier: String, values: [Compose]) {
        self.identifier = identifier
        self.values = values
    }

    /// Creates a Property with type-safe property definition and value.
    /// - Parameters:
    ///   - definition: A property definition that specifies the property type.
    ///   - value: The value conforming to the property definition's value type.
    public init<Game: SGFKit.Game, Value: PropertyValue>(
        _ definition: PropertyDefinition<Game, Value>,
        value: Value
    ) {
        self.init(
            identifier: definition.name,
            values: value.convertToComposes()
        )
    }
}

/// An enum indicating a composed value of a node.
public enum Compose: Hashable, Equatable, Sendable {
    /// A case indicating the value is not a composed value.
    case single(String?)

    /// A case indicating the value is a composed value.
    case compose(String?, String?)

    /// The first value.
    /// When the value is not composed, the value is just returned.
    /// When the value is composed, the first value is returned.
    public var first: String? {
        switch self {
        case .single(let string), .compose(let string, _): return string
        }
    }
    /// The second value.
    /// When the value is not composed, `nil` is just returned.
    /// When the value is composed, the second value is returned.
    public var second: String? {
        switch self {
        case .single: return nil
        case .compose(_, let second): return second
        }
    }
}
