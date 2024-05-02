public final class Parser {
    private let tokens: [Token]
    private var index = 0

    public init(tokens: [Token]) {
        self.tokens = tokens
    }

    public func perse() throws -> NonTerminalSymbols.Collection {
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
        index += 1

        let sequence = try sequence()
        var gameTrees: [NonTerminalSymbols.GameTree] = []
        while currentToken.kind != .rightParenthesis {
            gameTrees += try [gameTree()]
        }

        index += 1
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
        index += 1
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
        index += 1

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
        guard case .identifier(let letters) = currentToken.kind
        else {
            throw ParserError.unexpectedToken(expectedToken: .identifier, at: currentToken.position)
        }

        return NonTerminalSymbols.PropIdent(letters: letters)
    }

    private func propertyValue() throws -> NonTerminalSymbols.PropValue {
        try precondition(expected: .leftBracket)
        index += 1
        let value = try cValeType()
        try precondition(expected: .rightBracket)
        index += 1
        return NonTerminalSymbols.PropValue(type: value)
    }

    private func cValeType() throws -> NonTerminalSymbols.CValueType {
        let first = try value()
        if currentToken.kind == .colon {
            index += 1
            let second = try value()
            return .compose(first, second)
        } else {
            return .single(first)
        }
    }

    private func value() throws -> NonTerminalSymbols.ValueType? {
        guard case .value(let value) = currentToken.kind else {
            return nil
        }
        index += 1
        return NonTerminalSymbols.ValueType(value)
    }
}

extension Parser {
    private func precondition(expected: TokenKind.Case) throws {
        if currentToken.kind.case == expected { return }
        throw ParserError.unexpectedToken(expectedToken: expected, at: currentToken.position)
    }

    private var currentToken: Token {
        tokens[index]
    }
}

extension Parser {
    public static func parse(input: String) throws -> NonTerminalSymbols.Collection {
        let lexer = Lexer(input: input)
        let tokens = try lexer.lex()
        let parser = Parser(tokens: tokens)
        return try parser.perse()
    }
}

public enum ParserError: Error {
    case unexpectedToken(expectedToken: TokenKind.Case, at: String.Index)
}
