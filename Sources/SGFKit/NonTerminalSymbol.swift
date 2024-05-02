public protocol NonTerminalSymbol: Hashable, Sendable {
    /// Converts the symbols to a string in SGF.
    func convertToSGF() -> String
}

/// A namespace for non terminal symbol of EBNF which is defined in [the official documents](https://www.red-bean.com/sgf/sgf4.html).
public enum NonTerminalSymbols {
    public struct Collection: NonTerminalSymbol {
        public var gameTrees: [GameTree]

        public init(gameTrees: [GameTree]) {
            self.gameTrees = gameTrees
        }

        /// Converts the symbols to a string in SGF.
        public func convertToSGF() -> String {
            gameTrees.reduce("", { $0 + $1.convertToSGF() })
        }
    }

    public struct GameTree: NonTerminalSymbol {
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

    public struct Sequence: NonTerminalSymbol {
        public var nodes: [Node]

        public init(nodes: [Node]) {
            self.nodes = nodes
        }

        /// Converts the symbols to a string in SGF.
        public func convertToSGF() -> String {
            nodes.reduce("", { $0 + $1.convertToSGF() })
        }
    }

    public struct Node: NonTerminalSymbol{
        public var properties: [Property]

        public init(properties: [Property]) {
            self.properties = properties
        }

        /// Converts the symbols to a string in SGF.
        public func convertToSGF() -> String {
            ";" + properties.reduce("", { $0 + $1.convertToSGF() })
        }
    }

    public struct Property: NonTerminalSymbol {
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

    public struct PropIdent: NonTerminalSymbol, ExpressibleByStringLiteral {
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

    public struct PropValue: NonTerminalSymbol {
        public var type: CValueType

        public init(type: CValueType) {
            self.type = type
        }

        /// Converts the symbols to a string in SGF.
        public func convertToSGF() -> String {
            "[" + type.convertToSGF() + "]"
        }
    }

    public enum CValueType: NonTerminalSymbol {
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

    public struct ValueType: NonTerminalSymbol, ExpressibleByStringLiteral {
        public var value: String

        public init(_ value: String) {
            self.value = value
        }

        public init(stringLiteral value: StringLiteralType) {
            self.value = value
        }

        /// Converts the symbols to a string in SGF.
        public func convertToSGF() -> String {
            value
        }
    }
}
