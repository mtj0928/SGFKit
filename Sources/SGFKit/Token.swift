/// A data structure indicating a token of SGF.
public struct Token: Equatable, Hashable, Sendable {
    /// A position of the token in the original text.
    public var position: String.Index

    /// A kind of the token.
    public var kind: TokenKind

    init(_ kind: TokenKind, at position: String.Index) {
        self.position = position
        self.kind = kind
    }
}

/// An enum  indicating a kind and a value of a token of SGF.
public enum TokenKind: Equatable, Hashable, Sendable {
    /// A token indicating "(".
    case leftParenthesis

    /// A token indicating ")".
    case rightParenthesis

    /// A token indicating ";".
    case semicolon

    /// A token indicating ":".
    case colon

    /// A token indicating "[".
    case leftBracket

    /// A token indicating "]".
    case rightBracket

    /// A token indicating identifiers.
    case identifier(String)

    /// A token indicating value.
    case value(String)

    /// An enum  indicating only a kind of a token of SGF.
    public enum Case {
        /// A token indicating "(".
        case leftParenthesis
        /// A token indicating ")".
        case rightParenthesis
        /// A token indicating ";".
        case semicolon
        /// A token indicating ":".
        case colon
        /// A token indicating "[".
        case leftBracket
        /// A token indicating "]".
        case rightBracket
        /// A token indicating identifiers.
        case identifier
        /// A token indicating value.
        case value
    }

    /// A values indicating only a kind of the token.
    public var `case`: Case {
        switch self {
        case .leftParenthesis: .leftParenthesis
        case .rightParenthesis: .rightParenthesis
        case .semicolon: .semicolon
        case .colon: .colon
        case .leftBracket: .leftBracket
        case .rightBracket: .rightBracket
        case .identifier: .identifier
        case .value: .value
        }
    }
}
