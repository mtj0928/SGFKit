public final class Parser<Game: SGFGame> {
    let game: Game
    let tokens: [Token]
    private var index = 0

    public init(game: Game, tokens: [Token]) {
        self.game = game
        self.tokens = tokens
    }

    public func perse() throws -> SGFCollection<Game> {
        index = 0
        let collection = try collection()
        return collection
    }

    private func collection() throws -> SGFCollection<Game> {
        var gameTrees: [SGFGameTree<Game>] = []
        while index < tokens.count {
            gameTrees += try [gameTree()]
        }
        return SGFCollection(gameTrees: gameTrees)
    }

    private func gameTree() throws -> SGFGameTree<Game> {
        try precondition(expected: .leftParenthesis)
        index += 1

        let sequence = try sequence()
        var gameTrees: [SGFGameTree<Game>] = []
        while currentToken.kind != .rightParenthesis {
            gameTrees += try [gameTree()]
        }

        index += 1
        return SGFGameTree(sequence: sequence, gameTrees: gameTrees)
    }

    private func sequence() throws -> SGFSequence<Game> {
        var nodes: [SGFNode<Game>] = [try node()]

        while index < tokens.count {
            let previousIndex = index
            guard let node = try? node() else {
                index = previousIndex
                break
            }
            nodes += [node]
        }
        return SGFSequence(nodes: nodes)
    }

    private func node() throws -> SGFNode<Game> {
        try precondition(expected: .semicolon)
        index += 1
        var properties: [SGFProperty<Game>] = []
        while index < tokens.count {
            let previousIndex = index
            guard let property = try? property() else {
                index = previousIndex
                break
            }
            properties += [property]
        }
        return SGFNode(properties: properties)
    }

    private func property() throws -> SGFProperty<Game> {
        let (identifier, property) = try propertyIdentifier()
        let expectedType = property?.rootType
        index += 1

        func unionProperty(_ union: SGFValueTypeCollection<Game>.SGFValueUnion?) throws -> SGFPropValue<Game> {
            let previousIndex = index
            do {
                return try propertyValue(expectedType: union?.first)
            }
            catch {
                guard let secondType = expectedType?.union.second else {
                    throw error
                }
                index = previousIndex
                return try propertyValue(expectedType: secondType)
            }
        }

        switch expectedType {
        case .single(let union):
            let propValue = try unionProperty(union)
            return SGFProperty(identifier: identifier, values: [propValue])
        case .list(let union):
            var values: [SGFPropValue<Game>] = [try unionProperty(union)]
            while index < tokens.count {
                let previousIndex = index
                guard let node = try? unionProperty(union) else {
                    index = previousIndex
                    break
                }
                values.append(node)
            }
            return SGFProperty(identifier: identifier, values: values)
        case .elist(let union):
            var values: [SGFPropValue<Game>] = []
            while index < tokens.count {
                let previousIndex = index
                guard let node = try? unionProperty(union) else {
                    index = previousIndex
                    break
                }
                values.append(node)
            }
            return SGFProperty(identifier: identifier, values: values)
        case nil:
            let value = try unionProperty(nil)
            return SGFProperty(identifier: identifier, values: [value])
        }
    }

    private func propertyIdentifier() throws -> (SGFPropIdent<Game>, (any SGFPropertyEntryProtocol<Game>)?) {
        guard case .identifier(let letters) = currentToken.kind
        else {
            throw ParserError<Game>.unexpectedToken(expectedToken: .identifier, at: currentToken.position)
        }

        let property = try game.propertyTable.property(identifier: letters)
        return (SGFPropIdent(letters: letters), property)
    }

    private func propertyValue(expectedType: SGFValueTypeCollection<Game>.SGFCompose?) throws -> SGFPropValue<Game> {
        try precondition(expected: .leftBracket)
        index += 1
        let value = try cValeType(expectedType: expectedType)
        try precondition(expected: .rightBracket)
        index += 1
        return SGFPropValue(type: value)
    }

    private func cValeType(expectedType: SGFValueTypeCollection<Game>.SGFCompose?) throws -> SGFCValueType<Game> {
        switch expectedType {
        case .single(let expectedType):
            return .single(try value(expectedType: expectedType))
        case .compose(let firstExpectedType, let secondExpectedType):
            let first = try value(expectedType: firstExpectedType)
            try precondition(expected: .colon)
            index += 1
            let second = try value(expectedType: secondExpectedType)
            return .compose(first, second)
        case nil:
            return .single(try value(expectedType: nil))
        }
    }

    private func value(expectedType: SGFValueTypeCollection<Game>.SGFValuePrimitiveValue?) throws -> SGFValueType<Game> {
        switch expectedType {
        case .some(.none): return .none
        case .number:
            let value = try number()
            index += 1
            return value
        case .real:
            let value = try real()
            index += 1
            return value
        case .double:
            let value = try double()
            index += 1
            return value
        case .color:
            let value = try color()
            index += 1
            return value
        case .simpleText:
            let value = try simpleText()
            index += 1
            return value
        case .text:
            let value = try text()
            index += 1
            return value
        case .point:
            let value = try point()
            index += 1
            return value
        case .move:
            let value = try move()
            index += 1
            return value
        case .stone:
            let value = try stone()
            index += 1
            return value
        case nil:
            guard case .value(let text) = currentToken.kind else {
                return .unknown(nil)
            }
            index += 1
            return .unknown(text)
        }
    }

    private func number() throws -> SGFValueType<Game> {
        guard case .value(let text) = currentToken.kind,
              !text.contains("."),
              let number = Int(text)
        else {
            throw ParserError<Game>.typeMismatch(expectedType: .number, at: currentToken.position)
        }
        return .number(number)
    }

    private func real() throws -> SGFValueType<Game> {
        guard case .value(let text) = currentToken.kind,
              let number = Double(text)
        else {
            throw ParserError<Game>.typeMismatch(expectedType: .real, at: currentToken.position)
        }
        return .real(number)
    }

    private func double() throws -> SGFValueType<Game> {
        guard case .value(let text) = currentToken.kind,
              let number = Int(text),
              number == 1 || number == 2
        else {
            throw ParserError<Game>.typeMismatch(expectedType: .double, at: currentToken.position)
        }
        return .double(number == 1 ? .normal : .emphasized)
    }

    private func color() throws -> SGFValueType<Game> {
        guard case .value(let text) = currentToken.kind,
              text == "B" || text == "W"
        else {
            throw ParserError<Game>.typeMismatch(expectedType: .color, at: currentToken.position)
        }
        return .color(text == "B" ? .black : .white)
    }

    private func simpleText() throws -> SGFValueType<Game> {
        guard case .value(let text) = currentToken.kind else {
            throw ParserError<Game>.typeMismatch(expectedType: .simpleText, at: currentToken.position)
        }
        return .simpleText(text)
    }

    private func text() throws -> SGFValueType<Game> {
        guard case .value(let text) = currentToken.kind else {
            throw ParserError<Game>.typeMismatch(expectedType: .text, at: currentToken.position)
        }
        return .text(text)
    }

    private func point() throws -> SGFValueType<Game> {
        guard case .value(let text) = currentToken.kind,
              let point = try? Game.Point(value: text)
        else {
            throw ParserError<Game>.typeMismatch(expectedType: .point, at: currentToken.position)
        }
        return .point(point)
    }

    private func move() throws -> SGFValueType<Game> {
        guard case .value(let text) = currentToken.kind,
              let move = try? Game.Move(value: text)
        else {
            throw ParserError<Game>.typeMismatch(expectedType: .move, at: currentToken.position)
        }
        return .move(move)
    }

    private func stone() throws -> SGFValueType<Game> {
        guard case .value(let text) = currentToken.kind,
              let stone = try? Game.Stone(value: text)
        else {
            throw ParserError<Game>.typeMismatch(expectedType: .stone, at: currentToken.position)
        }
        return .stone(stone)
    }

}

extension Parser {
    private func precondition(expected: TokenKind.Case) throws {
        if currentToken.kind.case == expected { return }
        throw ParserError<Game>.unexpectedToken(expectedToken: expected, at: currentToken.position)
    }

    private var currentToken: Token {
        tokens[index]
    }
}

extension Parser {
    public static func parse(input: String, for game: Game) throws -> SGFCollection<Game> {
        let lexer = Lexer(input: input)
        let tokens = try lexer.lex()
        let parser = Parser(game: game, tokens: tokens)
        return try parser.perse()
    }
}

public enum ParserError<Game: SGFGame>: Error {
    case unexpectedToken(expectedToken: TokenKind.Case, at: String.Index)
    case typeMismatch(expectedType: SGFValueTypeCollection<Game>.SGFValuePrimitiveValue, at: String.Index)
}
