@testable import SGFKit
import XCTest

final class GoParserTests: XCTestCase {

    func testSimpleCase() throws {
        let input = "(;FF[4]GM[1];B[aa](;W[bb])(;W[cc]))"
        let game = Go()
        let collection = try GoParser.parse(input: input, for: game)

        let firstProperty = collection.gameTrees.first?.sequence.nodes.first?.properties.first
        XCTAssertEqual(firstProperty?.identifier.letters, "FF")
        XCTAssertEqual(firstProperty?.values.first?.type, .single(.number(4)))
        let properties = collection.gameTrees[0].sequence.nodes[0]
    }
}

