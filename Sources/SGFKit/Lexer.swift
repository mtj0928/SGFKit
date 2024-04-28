import Foundation

final class Lexer {
    private let input: String
    private var index: String.Index

    init(input: String) {
        self.input = input
        self.index = input.startIndex
    }

    func lex() throws -> [Token] {
        var tokens = [Token]()
        while index < input.endIndex {
            let character = input[index]
            switch character {
            case "(":
                tokens.append(Token(.leftParenthesis, at: index))
                index = input.index(after: index)
            case ")":
                tokens.append(Token(.rightParenthesis, at: index))
                index = input.index(after: index)
            case ";":
                tokens.append(Token(.semicolon, at: index))
                index = input.index(after: index)
            case "[":
                tokens.append(Token(.leftBracket, at: index))
                index = input.index(after: index)
                tokens += extractValueTypes()
            case "]":
                tokens.append(Token(.rightBracket, at: index))
                index = input.index(after: index)
            default:
                if character.isWhitespace || character.isNewline {
                    index = input.index(after: index)
                }
                else if character.isUppercase {
                    var characters: [Character] = []
                    repeat {
                        characters += [input[index]]
                        index = input.index(after: index)
                    } while index < input.endIndex && input[index].isUppercase
                    tokens.append(Token(.identifier(String(characters)), at: index))
                }
                else {
                    throw LexerError.invalidCharacter(index: index)
                }
            }
        }
        return tokens
    }

    private func extractValueTypes() -> [Token] {
        var tokens = [Token]()
        var characters: [Character] = []
        while index < input.endIndex {
            let character = input[index]

            if character == "\\" || character == "¥" {
                index = input.index(after: index)
                characters.append(input[index])
                index = input.index(after: index)
            } else if character == ":" {
                tokens.append(Token(.value(String(characters)), at: index))
                tokens.append(Token(.colon, at: index))
                characters = []
                index = input.index(after: index)
            } else if character == "]" {
                tokens.append(Token(.value(String(characters)), at: index))
                break
            } else {
                characters.append(character)
                index = input.index(after: index)
            }
        }
        return tokens
    }
}

enum LexerError: Error {
    case invalidCharacter(index: String.Index)
}
