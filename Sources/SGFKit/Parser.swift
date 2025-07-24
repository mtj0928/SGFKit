import Foundation

/// A parser for SGF.
public final class Parser {
    private let tokens: [Token]
    private var index = 0

    /// Creates an instance.
    public init(tokens: [Token]) {
        self.tokens = tokens
    }

    /// Parse the given tokens.
    ///
    /// ``ParserError`` is thrown on an error case.
    public func parse() throws -> NonTerminalSymbols.Collection {
        index = 0
        let collection = try collection()
        return collection
    }

    private func collection() throws -> NonTerminalSymbols.Collection {
        var gameTrees: [NonTerminalSymbols.GameTree] = []
        while index < tokens.count {
            gameTrees += try [gameTree()]
        }
        return NonTerminalSymbols.Collection(gameTrees: gameTrees)
    }

    private func gameTree() throws -> NonTerminalSymbols.GameTree {
        try precondition(expected: .leftParenthesis)
        try incrementIndex()

        let sequence = try sequence()
        var gameTrees: [NonTerminalSymbols.GameTree] = []
        while try currentToken().kind != .rightParenthesis {
            gameTrees += try [gameTree()]
        }

        try incrementIndex()
        return NonTerminalSymbols.GameTree(sequence: sequence, gameTrees: gameTrees)
    }

    private func sequence() throws -> NonTerminalSymbols.Sequence {
        var nodes = [try node()]

        while index < tokens.count {
            let previousIndex = index
            guard let node = try? node() else {
                index = previousIndex
                break
            }
            nodes += [node]
        }
        return NonTerminalSymbols.Sequence(nodes: nodes)
    }

    private func node() throws -> NonTerminalSymbols.Node {
        try precondition(expected: .semicolon)
        try incrementIndex()
        var properties: [NonTerminalSymbols.Property] = []
        while index < tokens.count {
            let previousIndex = index
            guard let property = try? property() else {
                index = previousIndex
                break
            }
            properties += [property]
        }
        return NonTerminalSymbols.Node(properties: properties)
    }

    private func property() throws -> NonTerminalSymbols.Property {
        let identifier = try propertyIdentifier()
        try incrementIndex()

        var values: [NonTerminalSymbols.PropValue] = []
        while index < tokens.count {
            let previousIndex = index
            guard let value = try? propertyValue() else {
                index = previousIndex
                break
            }
            values += [value]
        }
        return NonTerminalSymbols.Property(identifier: identifier, values: values)
    }

    private func propertyIdentifier() throws -> NonTerminalSymbols.PropIdent {
        guard case .identifier(let letters) = try currentToken().kind
        else {
            throw ParserError.unexpectedToken(expectedToken: .identifier, at: try currentToken().position)
        }

        return NonTerminalSymbols.PropIdent(letters: letters)
    }

    private func propertyValue() throws -> NonTerminalSymbols.PropValue {
        try precondition(expected: .leftBracket)
        try incrementIndex()
        let value = try cValeType()
        try precondition(expected: .rightBracket)
        try incrementIndex()
        return NonTerminalSymbols.PropValue(type: value)
    }

    private func cValeType() throws -> NonTerminalSymbols.CValueType {
        let first = try value()
        if try currentToken().kind == .colon {
            try incrementIndex()
            let second = try value()
            return .compose(first, second)
        } else {
            return .single(first)
        }
    }

    private func value() throws -> NonTerminalSymbols.ValueType? {
        guard case .value(let value) = try currentToken().kind else {
            return nil
        }
        try incrementIndex()
        return NonTerminalSymbols.ValueType(value)
    }
}

extension Parser {
    private func precondition(expected: TokenKind.Case) throws {
        let token = try currentToken()
        if token.kind.case == expected { return }
        throw ParserError.unexpectedToken(expectedToken: expected, at: token.position)
    }

    private func currentToken() throws -> Token {
        if tokens.count <= index {
            throw ParserError.indexOverflow
        }
        return tokens[index]
    }

    private func incrementIndex() throws {
        index += 1
        if tokens.count < index {
            throw ParserError.indexOverflow
        }
    }
}

extension Parser {

    /// Parse the given text as SGF.
    ///
    /// ``ParserError`` or ``LexerError`` are thrown on an error case.
    public static func parse(input: String) throws -> NonTerminalSymbols.Collection {
        let lexer = Lexer(input: input)
        let tokens = try lexer.tokenize()
        let parser = Parser(tokens: tokens)
        return try parser.parse()
    }
}

/// An error for ``Parser``.
public enum ParserError: Error, LocalizedError {
    /// A case indicating unexpected token appears.
    case unexpectedToken(expectedToken: TokenKind.Case, at: String.Index)

    /// A case indicating the expected token doesn't appear.
    case indexOverflow

    public var errorDescription: String? {
        switch self {
        case .unexpectedToken(let expectedToken, let position):
            "Unexpected token at position \(position). Expected: \(expectedToken)"
        case .indexOverflow:
            "Unexpected end of input while parsing SGF"
        }
    }
}
