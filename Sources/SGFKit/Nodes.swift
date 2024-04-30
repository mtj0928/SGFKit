public protocol SGFNodeProtocol: Hashable, Sendable {
    func string() -> String
}

public enum SGFNodes {
    public struct Collection: SGFNodeProtocol {
        public var gameTrees: [GameTree]

        public init(gameTrees: [GameTree]) {
            self.gameTrees = gameTrees
        }

        public func string() -> String {
            gameTrees.reduce("", { $0 + $1.string() })
        }
    }

    public struct GameTree: SGFNodeProtocol {
        public var sequence: Sequence
        public var gameTrees: [GameTree]

        public init(sequence: Sequence, gameTrees: [GameTree]) {
            self.sequence = sequence
            self.gameTrees = gameTrees
        }

        public func string() -> String {
            "(" + sequence.string() + gameTrees.reduce("", { $0 + $1.string() }) + ")"
        }
    }

    public struct Sequence: SGFNodeProtocol {
        public var nodes: [Node]

        public init(nodes: [Node]) {
            self.nodes = nodes
        }

        public func string() -> String {
            nodes.reduce("", { $0 + $1.string() })
        }
    }

    public struct Node: SGFNodeProtocol{
        public var properties: [Property]

        public init(properties: [Property]) {
            self.properties = properties
        }

        public func string() -> String {
            ";" + properties.reduce("", { $0 + $1.string() })
        }
    }

    public struct Property: SGFNodeProtocol {
        public var identifier: PropIdent
        public var values: [PropValue]

        public init(identifier: PropIdent, values: [PropValue]) {
            self.identifier = identifier
            self.values = values
        }

        public func string() -> String {
            identifier.string() + values.reduce("", { $0 + $1.string() })
        }
    }

    public struct PropIdent: SGFNodeProtocol, ExpressibleByStringLiteral {
        public var letters: String

        public init(letters: String) {
            self.letters = letters
        }

        public init(stringLiteral value: StringLiteralType) {
            self.letters = value
        }

        public func string() -> String {
            letters
        }
    }

    public struct PropValue: SGFNodeProtocol {
        public var type: CValueType

        public init(type: CValueType) {
            self.type = type
        }

        public func string() -> String {
            "[" + type.string() + "]"
        }
    }

    public enum CValueType: SGFNodeProtocol {
        case single(ValueType?)
        case compose(ValueType?, ValueType?)

        public func string() -> String {
            switch self {
            case .single(let value): return value?.string() ?? ""
            case .compose(let valueA, let valueB):
                return (valueA?.string() ?? "") + ":" + (valueB?.string() ?? "")
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

    public struct ValueType: SGFNodeProtocol, ExpressibleByStringLiteral {
        public var value: String

        public init(_ value: String) {
            self.value = value
        }

        public init(stringLiteral value: StringLiteralType) {
            self.value = value
        }

        public func string() -> String {
            value
        }
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
