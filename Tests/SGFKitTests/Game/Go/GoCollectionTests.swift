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

    func testAddNewNode() throws {
        let go = try Go(input: "(;FF[4];B[ab];B[ba])")
        let rootNode = go.tree.nodes[0]
        let node = rootNode.children[0] // ;B[ab]
        node.children.append(Node(properties: [Property(identifier: "B", values: [.single("cc")])]))

        XCTAssertEqual(go.tree.nodes[0].number, 0)
        XCTAssertEqual(go.tree.nodes[0].children[0].number, 1)
        XCTAssertEqual(go.tree.nodes[0].children[0].children[0].number, 2)
        XCTAssertEqual(go.tree.nodes[0].children[0].children[1].number, 3)
        XCTAssertEqual(go.tree.convertToSGF(), "(;FF[4];B[ab](;B[ba])(;B[cc]))")
    }

    func testRemoveNode() throws {
        let go = try Go(input: "(;FF[4];B[ab];B[ba])")
        let rootNode = go.tree.nodes[0]
        let node = rootNode.children[0] // ;B[ab]
        weak var childNode = node.children.first // ;B[ba]
        node.children.removeAll()

        XCTAssertEqual(go.tree.nodes[0].number, 0)
        XCTAssertEqual(go.tree.nodes[0].children[0].number, 1)
        XCTAssertEqual(go.tree.convertToSGF(), "(;FF[4];B[ab])")
        XCTAssertNil(childNode)
    }

    func testCopyNode() throws {
        let go = try Go(input: "(;FF[4];B[ab];B[ba])")
        let rootNode = go.tree.nodes[0]
        let node = rootNode.children[0] // ;B[ab]

        let copiedNode = node.copy()
        XCTAssertTrue(copiedNode !== node)
        XCTAssertEqual(copiedNode.propertyValue(of: .black), GoPoint(column: 1, row: 2))
        XCTAssertEqual(copiedNode.children[0].propertyValue(of: .black), GoPoint(column: 2, row: 1))
    }

    func testCopyCollection() throws {
        let go = try Go(input: "(;FF[4];B[ab];B[ba])")
        let collection = go.tree
        let copiedCollection = collection.copy()

        XCTAssertTrue(copiedCollection !== collection)
        XCTAssertEqual(copiedCollection.convertToSGF(), "(;FF[4];B[ab];B[ba])")
    }
}
