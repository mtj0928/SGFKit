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

    public let table: [String: SGFPropertyEntry<Go>]

    public init() {
        var table: [String: SGFPropertyEntry<Go>] = [:]
        for entry in SGFPropertyEntry<Go>.generalEntries + Go.goSpecificProperties {
            table[entry.name] = entry
        }
        self.table = table
    }

    public func property(identifier: String) throws -> SGFPropertyEntry<Go>? {
        table[identifier]
    }
}

extension Go {
    static let goSpecificProperties: [SGFPropertyEntry] = [.handicap, .komi, .territoryOfBlock, .territoryOfWhite]
}

extension SGFPropertyEntry<Go> {
    static let handicap = SGFPropertyEntry(name: "HA", type: .number)
    static let komi = SGFPropertyEntry(name: "KM", type: .real)
    static let territoryOfBlock = SGFPropertyEntry(name: "TB", type: .elist(of: .point))
    static let territoryOfWhite = SGFPropertyEntry(name: "TW", type: .elist(of: .point))
}

public typealias GoParser = Parser<Go>
