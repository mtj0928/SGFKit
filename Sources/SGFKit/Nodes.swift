public struct SGFCollection<Game: SGFGame> {
    var gameTrees: [SGFGameTree<Game>]
}

public struct SGFGameTree<Game: SGFGame> {
    var sequence: SGFSequence<Game>
    var gameTrees: [SGFGameTree<Game>]
}

public struct SGFSequence<Game: SGFGame> {
    var nodes: [SGFNode<Game>]
}

public struct SGFNode<Game: SGFGame> {
    var properties: [SGFProperty<Game>]
}

public struct SGFProperty<Game: SGFGame> {
    var identifier: SGFPropIdent<Game>
    var values: [SGFPropValue<Game>]
}

public struct SGFPropIdent<Game: SGFGame> {
    var letters: String
}

public struct SGFPropValue<Game: SGFGame> {
    var type: SGFCValueType<Game>
}

public enum SGFCValueType<Game: SGFGame>: Hashable, Sendable {
    case single(SGFValueType<Game>)
    case compose(SGFValueType<Game>, SGFValueType<Game>)
}

public enum SGFValueType<Game: SGFGame>: Hashable, Sendable {
    case none
    case number(Int)
    case real(Double)
    case double(SGFDouble)
    case color(SGFColor)
    case simpleText(String)
    case text(String)
    case point(Game.Point)
    case move(Game.Move)
    case stone(Game.Stone)
    case unknown(String?)
}

public enum SGFDouble: Int, Sendable {
    case normal = 1
    case emphasized = 2
}

public enum SGFColor: String, Sendable {
    case black = "B"
    case white = "W"
}

public struct SGFValueUnionType: Hashable, Sendable {
    public var first: SGFValueComposedType
    public var second: SGFValueComposedType?

    public init(_ first: SGFValueComposedType, or second: SGFValueComposedType?) {
        self.first = first
        self.second = second
    }

    public static func single(_ type: SGFValuePrimitiveType) -> SGFValueUnionType {
        SGFValueUnionType(.single(type), or: nil)
    }

    public static func compose(_ first: SGFValuePrimitiveType, _ second: SGFValuePrimitiveType) -> SGFValueUnionType {
        SGFValueUnionType(.compose(first, second), or: nil)
    }

    public static func union(_ first: SGFValueComposedType, _ second: SGFValueComposedType) -> SGFValueUnionType {
        SGFValueUnionType(first, or: second)
    }

    public static let none: SGFValueUnionType = .single(.none)
    public static let number: SGFValueUnionType = .single(.number)
    public static let real: SGFValueUnionType = .single(.real)
    public static let double: SGFValueUnionType = .single(.double)
    public static let color: SGFValueUnionType = .single(.color)
    public static let simpleText: SGFValueUnionType = .single(.simpleText)
    public static let text: SGFValueUnionType = .single(.text)
    public static let point: SGFValueUnionType = .single(.point)
    public static let move: SGFValueUnionType = .single(.move)
    public static let stone: SGFValueUnionType = .single(.stone)
}

public enum SGFValueComposedType: Hashable, Sendable {
    case single(SGFValuePrimitiveType)
    case compose(SGFValuePrimitiveType, SGFValuePrimitiveType)

    public static let none: SGFValueComposedType = .single(.none)
    public static let number: SGFValueComposedType = .single(.number)
    public static let real: SGFValueComposedType = .single(.real)
    public static let double: SGFValueComposedType = .single(.double)
    public static let color: SGFValueComposedType = .single(.color)
    public static let simpleText: SGFValueComposedType = .single(.simpleText)
    public static let text: SGFValueComposedType = .single(.text)
    public static let point: SGFValueComposedType = .single(.point)
    public static let move: SGFValueComposedType = .single(.move)
    public static let stone: SGFValueComposedType = .single(.stone)
}

public enum SGFValuePrimitiveType: Hashable, Sendable {
    case none
    case number
    case real
    case double
    case color
    case simpleText
    case text
    case point
    case move
    case stone
}
