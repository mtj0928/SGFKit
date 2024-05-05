import Foundation

/// A namespace for non terminal symbol of EBNF which is defined in [the official documents](https://www.red-bean.com/sgf/sgf4.html).
///
/// - SeeAlso: [the official documents](https://www.red-bean.com/sgf/sgf4.html)
public enum NonTerminalSymbols {

    public struct Collection: Hashable, Sendable {
        public var gameTrees: [GameTree]

        public init(gameTrees: [GameTree]) {
            self.gameTrees = gameTrees
        }

        /// Converts the symbols to a string in SGF.
        public func convertToSGF() -> String {
            gameTrees.reduce("", { $0 + $1.convertToSGF() })
        }
    }

    public struct GameTree: Hashable, Sendable {
        public var sequence: Sequence
        public var gameTrees: [GameTree]

        public init(sequence: Sequence, gameTrees: [GameTree]) {
            self.sequence = sequence
            self.gameTrees = gameTrees
        }

        /// Converts the symbols to a string in SGF.
        public func convertToSGF() -> String {
            "(" + sequence.convertToSGF() + gameTrees.reduce("", { $0 + $1.convertToSGF() }) + ")"
        }
    }

    public struct Sequence: Hashable, Sendable {
        public var nodes: [Node]

        public init(nodes: [Node]) {
            self.nodes = nodes
        }

        /// Converts the symbols to a string in SGF.
        public func convertToSGF() -> String {
            nodes.reduce("", { $0 + $1.convertToSGF() })
        }
    }

    public struct Node: Hashable, Sendable{
        public var properties: [Property]

        public init(properties: [Property]) {
            self.properties = properties
        }

        /// Converts the symbols to a string in SGF.
        public func convertToSGF() -> String {
            ";" + properties.reduce("", { $0 + $1.convertToSGF() })
        }
    }

    public struct Property: Hashable, Sendable {
        public var identifier: PropIdent
        public var values: [PropValue]

        public init(identifier: PropIdent, values: [PropValue]) {
            self.identifier = identifier
            self.values = values
        }

        /// Converts the symbols to a string in SGF.
        public func convertToSGF() -> String {
            identifier.convertToSGF() + values.reduce("", { $0 + $1.convertToSGF() })
        }
    }

    public struct PropIdent: Hashable, Sendable, ExpressibleByStringLiteral {
        public var letters: String

        public init(letters: String) {
            self.letters = letters
        }

        public init(stringLiteral value: StringLiteralType) {
            self.letters = value
        }

        /// Converts the symbols to a string in SGF.
        public func convertToSGF() -> String {
            letters
        }
    }

    public struct PropValue: Hashable, Sendable {
        public var type: CValueType

        public init(type: CValueType) {
            self.type = type
        }

        /// Converts the symbols to a string in SGF.
        public func convertToSGF() -> String {
            "[" + type.convertToSGF() + "]"
        }
    }

    public enum CValueType: Hashable, Sendable {
        case single(ValueType?)
        case compose(ValueType?, ValueType?)

        /// Converts the symbols to a string in SGF.
        public func convertToSGF() -> String {
            switch self {
            case .single(let value): return value?.convertToSGF() ?? ""
            case .compose(let valueA, let valueB):
                return (valueA?.convertToSGF() ?? "") + ":" + (valueB?.convertToSGF() ?? "")
            }
        }

        public var first: ValueType? {
            switch self {
            case .single(let value), .compose(let value, _): return value
            }
        }

        public var second: ValueType? {
            switch self {
            case .single: return nil
            case .compose(_, let value): return value
            }
        }
    }

    public struct ValueType: Hashable, Sendable, ExpressibleByStringLiteral {
        public var value: String

        public init(_ value: String) {
            self.value = value
        }

        public init(stringLiteral value: StringLiteralType) {
            self.value = value
        }

        /// Converts the symbols to a string in SGF.
        public func convertToSGF() -> String {
            // "]", "\" and ":" need to be escaped with "¥".
            return value
                .replacingOccurrences(of: "]", with: "¥]")
                .replacingOccurrences(of: "\\", with: "¥\\")
                .replacingOccurrences(of: ":", with: "¥:")
        }
    }
}
