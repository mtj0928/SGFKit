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
