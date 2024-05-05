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

    func testGoSpecificProperty() throws {
        let go = try Go(input: "(;FF[4]KM[6.5](;B[ab];B[ba]))")
        XCTAssertEqual(go.tree.nodes[0].propertyValue(of: .komi), 6.5)
    }

    func testNoneProperty()  throws {
        let go = try Go(input: "(;FF[4](;B[ab]DO[];B[ba]))")
        
        let node1 = go.tree.nodes[0].children[0] // ;B[ab]DO[]
        XCTAssertEqual(node1.propertyValue(of: .doubtful), SGFNone.none)
        XCTAssertTrue(node1.has(.doubtful))

        let node2 = node1.children[0] // ;B[ba]
        XCTAssertNil(node2.propertyValue(of: .doubtful))
        XCTAssertFalse(node2.has(.doubtful))
    }

    func testComplexBranch()  throws {
        let input = "(;FF[4]C[root](;C[a];C[b](;C[c])(;C[d];C[e]))(;C[f](;C[g];C[h];C[i])(;C[j])))"
        let go = try Go(input: input)
        let tree = go.tree

        let rootNode = tree.nodes[0] // ";FF[4]C[root]"
        XCTAssertEqual(rootNode.propertyValue(of: .fileFormat), 4)
        XCTAssertEqual(rootNode.propertyValue(of: .comment), "root")
        XCTAssertEqual(rootNode.number, 0)
        XCTAssertEqual(rootNode.children.count, 2)
        XCTAssertEqual(rootNode.parent?.number, tree.number)

        let nodeA = rootNode.children[0] // ;C[a]
        XCTAssertEqual(nodeA.propertyValue(of: .comment), "a")
        XCTAssertEqual(nodeA.children.count, 1)
        XCTAssertEqual(nodeA.number, 1)
        XCTAssertEqual(nodeA.parent?.number, rootNode.number)

        let nodeB = nodeA.children[0] // ;C[b]
        XCTAssertEqual(nodeB.propertyValue(of: .comment), "b")
        XCTAssertEqual(nodeB.children.count, 2)
        XCTAssertEqual(nodeB.number, 2)
        XCTAssertEqual(nodeB.parent?.number, nodeA.number)

        let nodeC = nodeB.children[0] // ;C[c]
        XCTAssertEqual(nodeC.propertyValue(of: .comment), "c")
        XCTAssertEqual(nodeC.children.count, 0)
        XCTAssertEqual(nodeC.number, 3)
        XCTAssertEqual(nodeC.parent?.number, nodeB.number)

        let nodeD = nodeB.children[1] // ;C[d]
        XCTAssertEqual(nodeD.propertyValue(of: .comment), "d")
        XCTAssertEqual(nodeD.children.count, 1)
        XCTAssertEqual(nodeD.number, 4)
        XCTAssertEqual(nodeD.parent?.number, nodeB.number)

        let nodeE = nodeD.children[0] // ;C[e]
        XCTAssertEqual(nodeE.propertyValue(of: .comment), "e")
        XCTAssertEqual(nodeE.children.count, 0)
        XCTAssertEqual(nodeE.number, 5)
        XCTAssertEqual(nodeE.parent?.number, nodeD.number)
    }

    func testInherit() throws {
        let go = try Go(input: "(;FF[4](;B[ab];B[ba]PM[3];B[c1]))")
        let node1 = go.tree.nodes[0].children[0] // ;B[ab]
        XCTAssertNil(node1.propertyValue(of: .printMoveMode))

        let node2 = node1.children[0] // ;B[ba]PM[3]
        XCTAssertEqual(node2.propertyValue(of: .printMoveMode), 3)

        let node3 = node2.children[0] // B[c1])
        XCTAssertEqual(node3.propertyValue(of: .printMoveMode), 3)
    }

    func testConvertToSGF() throws {
        let input = "(;FF[4]C[root](;C[a];C[b](;C[c])(;C[d];C[e]))(;C[f](;C[g];C[h];C[i])(;C[j])))"
        let go = try Go(input: input)
        XCTAssertEqual(go.tree.convertToSGF(), input)
    }

    func testConvertToSGFWithEscaping() throws {
        let input = "(;FF[4]C[¥]¥:¥\\foo])"
        let go = try Go(input: input)
        XCTAssertEqual(go.tree.convertToSGF(), input)
    }
}
