// MARK: - Protocols

public protocol PropertyValue {
    init?(_ property: Property)
}

public protocol PropertyListElementValue: PropertyValue {
    init?(_ compose: Compose)
}

extension PropertyListElementValue {
    public init?(_ property: Property) {
        guard let first = property.values.first else { return nil }
        self.init(first)
    }
}

public protocol PropertyPrimitiveValue: PropertyListElementValue {
    init?(primitiveValue: String?)
}

extension PropertyPrimitiveValue {
    public init?(_ compose: Compose) {
        self.init(primitiveValue: compose.first)
    }
}

// MARK: - Union

public enum SGFUnion<First: PropertyValue, Second: PropertyValue>: PropertyValue {
    case first(First)
    case second(Second)

    public init?(_ property: Property) {
        if let first = First(property) {
            self = .first(first)
        } else if let second = Second(property) {
            self = .second(second)
        } else {
            return nil
        }
    }
}

// MARK: - List

public struct SGFList<Element: PropertyListElementValue>: PropertyValue {
    var values: [Element]

    public init?(_ property: Property) {
        if property.values.isEmpty { return nil }

        let elements = property.values.compactMap({ Element($0) })
        if elements.count != property.values.count {
            return nil
        }

        self.values = elements
    }
}

public struct SGFEList<Element: PropertyListElementValue>: PropertyValue {
    var values: [Element]

    public init?(_ property: Property) {
        let elements = property.values.compactMap({ Element($0) })
        if elements.count != property.values.count {
            return nil
        }

        self.values = elements
    }
}

// MARK: - Compose

public struct SGFCompose<First: PropertyPrimitiveValue, Second: PropertyPrimitiveValue>: PropertyListElementValue {
    let first: First
    let second: Second

    public init?(_ compose: Compose) {
        guard case .compose(let first, let second) = compose,
              let first = First(primitiveValue: first),
              let second = Second(primitiveValue: second)
        else {
            return nil
        }

        self.first = first
        self.second = second
    }
}

// MARK: - Primitive Value

public enum SGFNone: PropertyPrimitiveValue, Hashable, Sendable {
    case none

    public init?(primitiveValue: String?) {
        self = .none
    }
}

extension Int: PropertyPrimitiveValue {
    public init?(primitiveValue: String?) {
        guard let primitiveValue, let number = Int(primitiveValue) else { return nil }
        self = number
    }
}

extension Double: PropertyPrimitiveValue {
    public init?(primitiveValue: String?) {
        guard let primitiveValue, let number = Double(primitiveValue) else { return nil }
        self = number
    }
}

extension String: PropertyPrimitiveValue {
    public init?(primitiveValue: String?) {
        guard let primitiveValue else { return nil }
        self = primitiveValue
    }
}

public typealias SGFReal = Double
public typealias SGFText = String
public typealias SGFSimpleText = String

public enum SGFDouble: Int, Sendable, PropertyPrimitiveValue {
    case normal = 1
    case emphasized = 2

    public init?(primitiveValue: String?) {
        guard let primitiveValue,
              let intValue = Int(primitiveValue),
              let value = SGFDouble(rawValue: intValue)
        else { return nil }
        self = value
    }
}

public enum SGFColor: String, Sendable, PropertyPrimitiveValue {
    case black = "B"
    case white = "W"

    public init?(primitiveValue: String?) {
        guard let primitiveValue,
              let value = SGFColor(rawValue: primitiveValue)
        else { return nil }
        self = value
    }
}
