public enum SGFNodes<Game: SGFGame> {
    public struct Collection {
        var gameTrees: [GameTree]
    }

    public struct GameTree {
        var sequence: Sequence
        var gameTrees: [GameTree]
    }

    public struct Sequence {
        var nodes: [Node]
    }

    public struct Node {
        var properties: [Property]
    }

    public struct Property {
        var identifier: PropIdent
        var values: [PropValue]
    }

    public struct PropIdent {
        var letters: String
    }

    public struct PropValue {
        var type: CValueType
    }

    public enum CValueType: Hashable, Sendable {
        case single(ValueType)
        case compose(ValueType, ValueType)
    }

    public enum ValueType: Hashable, Sendable {
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
}

public enum SGFDouble: Int, Sendable {
    case normal = 1
    case emphasized = 2
}

public enum SGFColor: String, Sendable {
    case black = "B"
    case white = "W"
}
