public enum SGFNodes {
    public struct Collection: Hashable, Sendable {
        public var gameTrees: [GameTree]

        public init(gameTrees: [GameTree]) {
            self.gameTrees = gameTrees
        }
    }

    public struct GameTree: Hashable, Sendable {
        public var sequence: Sequence
        public var gameTrees: [GameTree]

        public init(sequence: Sequence, gameTrees: [GameTree]) {
            self.sequence = sequence
            self.gameTrees = gameTrees
        }
    }

    public struct Sequence: Hashable, Sendable {
        public var nodes: [Node]

        public init(nodes: [Node]) {
            self.nodes = nodes
        }
    }

    public struct Node: Hashable, Sendable {
        public var properties: [Property]

        public init(properties: [Property]) {
            self.properties = properties
        }
    }

    public struct Property: Hashable, Sendable {
        public var identifier: PropIdent
        public var values: [PropValue]

        public init(identifier: PropIdent, values: [PropValue]) {
            self.identifier = identifier
            self.values = values
        }
    }

    public struct PropIdent: Hashable, Sendable {
        public var letters: String

        public init(letters: String) {
            self.letters = letters
        }
    }

    public struct PropValue: Hashable, Sendable {
        public var type: CValueType

        public init(type: CValueType) {
            self.type = type
        }
    }

    public enum CValueType: Hashable, Sendable {
        case single(ValueType?)
        case compose(ValueType?, ValueType?)
    }

    public struct ValueType: Hashable, Sendable, ExpressibleByStringLiteral {
        public var value: String

        public init(_ value: String) {
            self.value = value
        }

        public init(stringLiteral value: StringLiteralType) {
            self.value = value
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
