@testable import SGFKit
import XCTest

final class GoTests: XCTestCase {

    func testProperty() throws {
        let go = try Go(input: "(;FF[4](;B[ab];B[ba]))")
        let gameTree = go.tree.gameTrees[0].gameTrees[0]

        let result1 = gameTree.nodes[0].propertyValue(of: .black)
        XCTAssertEqual(result1, GoPoint(column: 1, row: 2))

        let result2 = gameTree.nodes[1].propertyValue(of: .black)
        XCTAssertEqual(result2, GoPoint(column: 2, row: 1))
    }

    func testNoneProperty()  throws {
        let go = try Go(input: "(;FF[4](;B[ab]DO[];B[ba]))")
        let gameTree = go.tree.gameTrees[0].gameTrees[0]
        
        let node1 = gameTree.nodes[0]
        XCTAssertEqual(node1.propertyValue(of: .doubtful), SGFNone.none)
        XCTAssertTrue(node1.has(of: .doubtful))

        let node2 = gameTree.nodes[1]
        XCTAssertNil(node2.propertyValue(of: .doubtful))
        XCTAssertFalse(node2.has(of: .doubtful))
    }
}
