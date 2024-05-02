// MARK: - Protocols

public protocol PropertyValue {
    init?(_ property: Property)
    func convertToComposes() -> [Compose]
}

public protocol PropertyListElementValue: PropertyValue {
    init?(_ compose: Compose)
    func convertToCompose() -> Compose
}

extension PropertyListElementValue {
    public init?(_ property: Property) {
        guard let first = property.values.first else { return nil }
        self.init(first)
    }

    public func convertToComposes() -> [Compose] {
        [convertToCompose()]
    }
}

public protocol PropertyPrimitiveValue: PropertyListElementValue {
    init?(primitiveValue: String?)

    func convertToPrimitiveValue() -> String?
}

extension PropertyPrimitiveValue {
    public init?(_ compose: Compose) {
        self.init(primitiveValue: compose.first)
    }

    public func convertToCompose() -> Compose {
        .single(self.convertToPrimitiveValue())
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

    public func convertToComposes() -> [Compose] {
        switch self {
        case .first(let first): return first.convertToComposes()
        case .second(let second): return second.convertToComposes()
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

    public func convertToComposes() -> [Compose] {
        values.map { $0.convertToCompose() }
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

    public func convertToComposes() -> [Compose] {
        values.map { $0.convertToCompose() }
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

    public func convertToCompose() -> Compose {
        .compose(first.convertToPrimitiveValue(), second.convertToPrimitiveValue())
    }
}

// MARK: - Primitive Value

public enum SGFNone: PropertyPrimitiveValue, Hashable, Sendable {
    case none

    public init?(primitiveValue: String?) {
        self = .none
    }

    public func convertToPrimitiveValue() -> String? {
        nil
    }
}

extension Int: PropertyPrimitiveValue {
    public init?(primitiveValue: String?) {
        guard let primitiveValue, let number = Int(primitiveValue) else { return nil }
        self = number
    }

    public func convertToPrimitiveValue() -> String? {
        String(self)
    }
}

extension Double: PropertyPrimitiveValue {
    public init?(primitiveValue: String?) {
        guard let primitiveValue, let number = Double(primitiveValue) else { return nil }
        self = number
    }

    public func convertToPrimitiveValue() -> String? {
        String(self)
    }
}

extension String: PropertyPrimitiveValue {
    public init?(primitiveValue: String?) {
        guard let primitiveValue else { return nil }
        self = primitiveValue
    }

    public func convertToPrimitiveValue() -> String? {
        self
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

    public func convertToPrimitiveValue() -> String? {
        String(rawValue)
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

    public func convertToPrimitiveValue() -> String? {
        rawValue
    }
}
