public protocol SGFGame {
    associatedtype Point: SGFPoint
    associatedtype Move: SGFMove
    associatedtype Stone: SGFStone
    associatedtype PropertyTable: SGFPropertyTable where PropertyTable.Game == Self

    var propertyTable: PropertyTable { get }
}

public protocol SGFPropertyTable {
    associatedtype Game: SGFGame
    func property(identifier: String) throws -> (any SGFPropertyEntryProtocol<Game>)?
}

public protocol SGFPoint: Hashable, Sendable {
    init(value: String) throws
}

public protocol SGFMove: Hashable, Sendable {
    init(value: String) throws
}

public protocol SGFStone: Hashable, Sendable {
    init(value: String) throws
}
