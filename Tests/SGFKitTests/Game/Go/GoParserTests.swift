@testable import SGFKit
import XCTest

final class GoParserTests: XCTestCase {

    func testSimpleCase() throws {
        let input = "(;FF[4]GM[1];B[aa](;W[bb])(;W[cc]))"
        let collection = try Parser.parse(input: input)

        let firstProperty = collection.gameTrees.first?.sequence.nodes.first?.properties.first
        XCTAssertEqual(
            firstProperty,
            SGFNodes.Property(
                identifier: SGFNodes.PropIdent(letters: "FF"),
                values: [SGFNodes.PropValue(type: .single("4"))]
            )
        )
    }
}
