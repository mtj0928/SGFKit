@testable import SGFKit
import XCTest

final class GoTests: XCTestCase {

    func testProperty() throws {
        let go = try Go(input: "(;FF[4](;B[ab];B[ba]))")

        let node1 = go.tree.nodes[0].children[0]
        let result1 = node1.propertyValue(of: .black)
        XCTAssertEqual(result1, GoPoint(column: 1, row: 2))

        let node2 = node1.children[0]
        let result2 = node2.propertyValue(of: .black)
        XCTAssertEqual(result2, GoPoint(column: 2, row: 1))
    }

    func testNoneProperty()  throws {
        let go = try Go(input: "(;FF[4](;B[ab]DO[];B[ba]))")
        
        let node1 = go.tree.nodes[0].children[0] // ;B[ab]DO[]
        XCTAssertEqual(node1.propertyValue(of: .doubtful), SGFNone.none)
        XCTAssertTrue(node1.has(of: .doubtful))

        let node2 = node1.children[0] // ;B[ba]
        XCTAssertNil(node2.propertyValue(of: .doubtful))
        XCTAssertFalse(node2.has(of: .doubtful))
    }

    func test2()  throws {
        let input = "(;FF[4]C[root](;C[a];C[b](;C[c])(;C[d];C[e]))(;C[f](;C[g];C[h];C[i])(;C[j])))"
        let go = try Go(input: input)
        let tree = go.tree

        let rootNode = tree.nodes[0] // ";FF[4]C[root]"
        XCTAssertEqual(rootNode.propertyValue(of: .fileFormat), 4)
        XCTAssertEqual(rootNode.propertyValue(of: .comment), "root")
        XCTAssertEqual(rootNode.id, 0)
        XCTAssertEqual(rootNode.children.count, 2)
        XCTAssertNil(rootNode.parent)

        let nodeA = rootNode.children[0] // ;C[a]
        XCTAssertEqual(nodeA.propertyValue(of: .comment), "a")
        XCTAssertEqual(nodeA.children.count, 1)
        XCTAssertEqual(nodeA.id, 1)
        XCTAssertEqual(nodeA.parent?.id, rootNode.id)

        let nodeB = nodeA.children[0] // ;C[b]
        XCTAssertEqual(nodeB.propertyValue(of: .comment), "b")
        XCTAssertEqual(nodeB.children.count, 2)
        XCTAssertEqual(nodeB.id, 2)
        XCTAssertEqual(nodeB.parent?.id, nodeA.id)

        let nodeC = nodeB.children[0] // ;C[c]
        XCTAssertEqual(nodeC.propertyValue(of: .comment), "c")
        XCTAssertEqual(nodeC.children.count, 0)
        XCTAssertEqual(nodeC.id, 3)
        XCTAssertEqual(nodeC.parent?.id, nodeB.id)

        let nodeD = nodeB.children[1] // ;C[d]
        XCTAssertEqual(nodeD.propertyValue(of: .comment), "d")
        XCTAssertEqual(nodeD.children.count, 1)
        XCTAssertEqual(nodeD.id, 4)
        XCTAssertEqual(nodeD.parent?.id, nodeB.id)

        let nodeE = nodeD.children[0] // ;C[e]
        XCTAssertEqual(nodeE.propertyValue(of: .comment), "e")
        XCTAssertEqual(nodeE.children.count, 0)
        XCTAssertEqual(nodeE.id, 5)
        XCTAssertEqual(nodeE.parent?.id, nodeD.id)

    }
}
