@testable import SGFKit
import XCTest

final class LexerTests: XCTestCase {

    func testSimpleCase() throws {
        let input = """
        (;FF[4]C[root](;C[a];C[b](;C[c])
        (;C[d];C[e]))
        (;C[f](;C[g];C[h];C[i])
        (;C[j])))
        """
        let tokens = try Lexer(input: input).tokenize()
        let kinds = tokens.map { $0.kind }
        XCTAssertEqual(kinds, [
            .leftParenthesis,   // (
            .semicolon,         // ;
            .identifier("FF"),  // FF
            .leftBracket,       // [
            .value("4"),        // 4
            .rightBracket,      // ]
            .identifier("C"),   // C
            .leftBracket,       // [
            .value("root"),     // root
            .rightBracket,      // ]
            .leftParenthesis,   // (
            .semicolon,         // ;
            .identifier("C"),   // C
            .leftBracket,       // [
            .value("a"),        // a
            .rightBracket,      // ]
            .semicolon,         // ;
            .identifier("C"),   // C
            .leftBracket,       // [
            .value("b"),        // b
            .rightBracket,      // ]
            .leftParenthesis,   // (
            .semicolon,         // ;
            .identifier("C"),   // C
            .leftBracket,       // [
            .value("c"),        // c
            .rightBracket,      // ]
            .rightParenthesis,  // )
            .leftParenthesis,   // (
            .semicolon,         // ;
            .identifier("C"),   // C
            .leftBracket,       // [
            .value("d"),        // d
            .rightBracket,      // ]
            .semicolon,         // ;
            .identifier("C"),   // C
            .leftBracket,       // [
            .value("e"),        // e
            .rightBracket,      // ]
            .rightParenthesis,  // )
            .rightParenthesis,  // )
            .leftParenthesis,   // (
            .semicolon,         // ;
            .identifier("C"),   // C
            .leftBracket,       // [
            .value("f"),        // f
            .rightBracket,      // ]
            .leftParenthesis,   // (
            .semicolon,         // ;
            .identifier("C"),   // C
            .leftBracket,       // [
            .value("g"),        // g
            .rightBracket,      // ]
            .semicolon,         // ;
            .identifier("C"),   // C
            .leftBracket,       // [
            .value("h"),        // h
            .rightBracket,      // ]
            .semicolon,         // ;
            .identifier("C"),   // C
            .leftBracket,       // [
            .value("i"),        // i
            .rightBracket,      // ]
            .rightParenthesis,  // )
            .leftParenthesis,   // (
            .semicolon,         // ;
            .identifier("C"),   // C
            .leftBracket,       // [
            .value("j"),        // j
            .rightBracket,      // ]
            .rightParenthesis,  // )
            .rightParenthesis,  // )
            .rightParenthesis   // )
        ])
    }
}

