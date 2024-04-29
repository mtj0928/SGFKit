public struct Go: SGFGame {
    public typealias Stone = Point
    public typealias Point = GoPoint
    public typealias Move = Point

    public let propertyTable = GoPropertyTable()
}

public struct GoPoint: SGFPoint, SGFStone, SGFMove, Hashable, Sendable {
    public var column: Int
    public var row: Int

    public init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }

    public init(value: String) throws {
        let characters: [Character] = Array(value)
        guard characters.count == 2,
              let column = Self.alphabetToNumber(characters[0]),
              let row = Self.alphabetToNumber(characters[1])
        else {
            throw ParserError.invalidCharacter
        }
        self.init(column: column, row: row)
    }

    static private func alphabetToNumber(_ char: Character) -> Int? {
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

    public enum ParserError: Error {
        case invalidCharacter
    }
}

public struct GoPropertyTable: SGFPropertyTable {
    public typealias Game = Go

    public let table: [String: any SGFPropertyEntryProtocol<Go>]

    public init() {
        var table: [String: any SGFPropertyEntryProtocol<Go>] = [:]
        for entry in SGFGeneralProperties<Go>.generalEntries + Go.goSpecificProperties {
            table[entry.name] = entry
        }
        self.table = table
    }

    public func property(identifier: String) throws -> (any SGFPropertyEntryProtocol<Go>)? {
        table[identifier]
    }
}

extension Go {
    static let goSpecificProperties: [any SGFPropertyEntryProtocol<Go>] = [
        SGFGeneralProperties<Go>.handicap,
        SGFGeneralProperties<Go>.komi,
        SGFGeneralProperties<Go>.territoryOfBlock,
        SGFGeneralProperties<Go>.territoryOfWhite
    ]
}

extension SGFGeneralProperties<Go> {
    static var handicap: Entry<Int> { Entry<Int>(name: "HA", type: .number) }
    static var komi: Entry<Double> { Entry<Double>(name: "KM", type: .real) }
    static var territoryOfBlock: Entry<EList<Go.Point>> { Entry<EList<Go.Point>>(name: "TB", type: .elist(of: .point)) }
    static var territoryOfWhite: Entry<EList<Go.Point>> { Entry<EList<Go.Point>>(name: "TW", type: .elist(of: .point)) }
}

public typealias GoParser = Parser<Go>
