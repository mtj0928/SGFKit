public protocol Game {
    associatedtype Move: SGFKit.Move
    associatedtype Point: SGFKit.Point
    associatedtype Stone: SGFKit.Stone

    init(tree: TreeModels.Collection<Self>)
}

extension Game {
    public init(collection: NonTerminalSymbols.Collection) {
        self.init(tree: TreeModels.simplify(collection: collection))
    }

    public init(input: String) throws {
        let collection = try Parser.parse(input: input)
        self.init(collection: collection)
    }
}

public protocol Move: PropertyPrimitiveValue {
}

public protocol Point: PropertyPrimitiveValue {
}

public protocol Stone: PropertyPrimitiveValue {
}
