@testable import SGFKit
import XCTest

final class LexerTests: XCTestCase {

    func testSimpleCase() throws {
        let input = "(;FF[4]GM[1];B[aa](;W[bb])(;W[cc]))"
        let tokens = try Lexer(input: input).lex()
        let kinds = tokens.map { $0.kind }
        XCTAssertEqual(kinds, [
            .leftParenthesis,
            .semicolon,
            .identifier("FF"),
            .leftBracket,
            .value("4"),
            .rightBracket,
            .identifier("GM"),
            .leftBracket,
            .value("1"),
            .rightBracket,
            .semicolon,
            .identifier("B"),
            .leftBracket,
            .value("aa"),
            .rightBracket,
            .leftParenthesis,
            .semicolon,
            .identifier("W"),
            .leftBracket,
            .value("bb"),
            .rightBracket,
            .rightParenthesis,
            .leftParenthesis,
            .semicolon,
            .identifier("W"),
            .leftBracket,
            .value("cc"),
            .rightBracket,
            .rightParenthesis,
            .rightParenthesis,
        ])
    }

    func testCommentCase() throws {
        let input = "(;FF[4]GM[1];B[[ AAA\\]])"
        let tokens = try Lexer(input: input).lex()
        let kinds = tokens.map { $0.kind }
        XCTAssertEqual(kinds, [
            .leftParenthesis,
            .semicolon,
            .identifier("FF"),
            .leftBracket,
            .value("4"),
            .rightBracket,
            .identifier("GM"),
            .leftBracket,
            .value("1"),
            .rightBracket,
            .semicolon,
            .identifier("B"),
            .leftBracket,
            .value("[ AAA]"),
            .rightBracket,
            .rightParenthesis,
        ])
    }
}

