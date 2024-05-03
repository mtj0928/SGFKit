/// A protocol indicating a game.
public protocol Game {
    /// A move type in the game.
    associatedtype Move: SGFKit.Move

    /// A point type in the game.
    associatedtype Point: SGFKit.Point

    /// A stone type in the game.
    associatedtype Stone: SGFKit.Stone

    /// A tree of the game.
    var tree: Collection<Self> { get }

    /// Creates an object.
    init(tree: Collection<Self>)
}

extension Game {
    /// Creates an object.
    public init(collection: NonTerminalSymbols.Collection) {
        self.init(tree: Collection(collection))
    }

    /// Creates an object.
    public init(input: String) throws {
        let collection = try Parser.parse(input: input)
        self.init(collection: collection)
    }
}

/// A protocol indicating a move type.
///
/// - SeeAlso: [The official documents](https://www.red-bean.com/sgf/sgf4.html#types)
public protocol Move: PropertyPrimitiveValue {
}

/// A protocol indicating a point type.
///
/// - SeeAlso: [The official documents](https://www.red-bean.com/sgf/sgf4.html#types)
public protocol Point: PropertyPrimitiveValue {
}

/// A protocol indicating a stone type.
///
/// - SeeAlso: [The official documents](https://www.red-bean.com/sgf/sgf4.html#types)
public protocol Stone: PropertyPrimitiveValue {
}
