@testable import SGFKit
import XCTest

final class GoCollectionTests: XCTestCase {

    func testAddProperty() throws {
        let go = try Go(input: "(;FF[4];B[ab];B[ba])")
        let rootNode = go.tree.nodes[0]
        let node = rootNode.children[0] // ;B[ab]

        let point = GoPoint(column: 2, row: 28)
        node.addProperty(point, to: .black) // bB
        XCTAssertEqual(node.propertyValue(of: .black), point)

        XCTAssertEqual(go.tree.convertToSGF(), "(;FF[4];B[bB];B[ba])")
    }

    func testRemoveProperty() throws {
        let go = try Go(input: "(;FF[4];B[ab]C[a];B[ba])")
        let rootNode = go.tree.nodes[0]
        let node = rootNode.children[0] // ;B[ab]C[a]
        XCTAssertEqual(node.propertyValue(of: .comment), "a")

        node.removeProperty(of: .comment)
        XCTAssertNil(node.propertyValue(of: .comment))
        XCTAssertFalse(node.has(.comment))
        XCTAssertEqual(go.tree.convertToSGF(), "(;FF[4];B[ab];B[ba])")
    }
}
