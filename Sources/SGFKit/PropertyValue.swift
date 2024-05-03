// MARK: - Protocols

/// A protocol which can be a value of a node property.
public protocol PropertyValue: Hashable, Sendable {
    init?(_ composes: [Compose])

    /// Converts the node to an array of a ``Compose`` .
    func convertToComposes() -> [Compose]
}

/// A protocol which can be an element of a list.
public protocol PropertyListElementValue: PropertyValue {
    init?(_ compose: Compose)

    /// Converts the node to an ``Compose``.
    func convertToCompose() -> Compose
}

extension PropertyListElementValue {
    public init?(_ composes: [Compose]) {
        guard let first = composes.first else { return nil }
        self.init(first)
    }

    public func convertToComposes() -> [Compose] {
        [convertToCompose()]
    }
}

/// A protocol which can be a primitive value.
public protocol PropertyPrimitiveValue: PropertyListElementValue {
    init?(primitiveValue: String?)

    /// Converts the node to a primitive value.
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

/// A data structure indicating a union type.
public enum SGFUnion<First: PropertyValue, Second: PropertyValue>: PropertyValue {
    case first(First)
    case second(Second)

    public init?(_ composes: [Compose]) {
        if let first = First(composes) {
            self = .first(first)
        } else if let second = Second(composes) {
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

/// A data structure indicating a list type for SGF.
///
/// > Note: List in SGF doesn't allow empty elements.
public struct SGFList<Element: PropertyListElementValue>: PropertyValue {
    public var values: [Element]

    public init?(_ composes: [Compose]) {
        if composes.isEmpty { return nil }

        let elements = composes.compactMap({ Element($0) })
        if elements.count != composes.count {
            return nil
        }

        self.values = elements
    }

    public func convertToComposes() -> [Compose] {
        values.map { $0.convertToCompose() }
    }
}

/// A data structure indicating an elist type for SGF.
/// This type can have an empty element.
public struct SGFEList<Element: PropertyListElementValue>: PropertyValue {
    public var values: [Element]

    public init?(_ composes: [Compose]) {
        let elements = composes.compactMap({ Element($0) })
        if elements.count != composes.count {
            return nil
        }

        self.values = elements
    }

    public func convertToComposes() -> [Compose] {
        values.map { $0.convertToCompose() }
    }
}

// MARK: - Compose

/// A data structure indicating a compose  type for SGF.
public struct SGFCompose<First: PropertyPrimitiveValue, Second: PropertyPrimitiveValue>: PropertyListElementValue {
    public var first: First
    public var second: Second

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

/// A data structure indicating none type for SGF.
public enum SGFNone: PropertyPrimitiveValue, Hashable, Sendable {
    case none

    public init?(primitiveValue: String?) {
        guard primitiveValue == "" else { return nil }
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

/// A typealias  indicating Real type for SGF.
public typealias SGFReal = Double

/// A typealias  indicating Text type for SGF.
public typealias SGFText = String

/// A typealias  indicating Simple text type for SGF.
public typealias SGFSimpleText = String

/// An enum  indicating Double type for SGF.
///
/// > Note: Double in SGF is not the same Double in Swift.
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

/// An enum  indicating Color type for SGF.
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
