public struct Go: Game {
    public typealias Point = GoPoint
    public typealias Move = GoPoint
    public typealias Stone = GoPoint

    let tree: Collection<Self>

    public init(tree: Collection<Self>) {
        self.tree = tree
    }
}

public struct GoPoint: Point, Move, Stone, Hashable, Sendable {
    public var column: Int
    public var row: Int

    public init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }

    public init?(primitiveValue: String?) {
        guard let primitiveValue else { return nil }
        let characters: [Character] = Array(primitiveValue)

        guard characters.count == 2,
              let column = alphabetToNumber(characters[0]),
              let row = alphabetToNumber(characters[1])
        else {
            return nil
        }
        self.init(column: column, row: row)
    }
}

private func alphabetToNumber(_ char: Character) -> Int? {
    guard let scalarValue = char.unicodeScalars.first.flatMap({ Int($0.value) }) else { return nil }
    switch scalarValue {
    case 97...122: // 'a' to 'z'
        return scalarValue - 96
    case 65...90: // 'A' to 'Z'
        return scalarValue - 38
    default:
        return nil
    }
}

// MARK: - Custom Properties

extension PropertyDefinition where Game == Go {
    // None
    public static var territoryBlack: Property<EList<Point>> { "TB" }
    public static var territoryWhite: Property<EList<Point>> { "TW" }

    // game-info
    public static var handicap: Property<Number> { "HA" }
    public static var komi: Property<Real> { "KM" }
}
