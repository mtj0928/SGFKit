@testable import SGFKit
import Testing

@Suite
struct GoTests {

    @Test
    func property() throws {
        let go = try Go(input: "(;FF[4](;B[ab];B[ba]))")

        let node1 = go.tree.nodes[0].children[0]
        let result1 = node1.propertyValue(of: .black)
        #expect(result1 == GoPoint(column: 1, row: 2))

        let node2 = node1.children[0]
        let result2 = node2.propertyValue(of: .black)
        #expect(result2 == GoPoint(column: 2, row: 1))
    }

    @Test
    func goSpecificProperty() throws {
        let go = try Go(input: "(;FF[4]KM[6.5](;B[ab];B[ba]))")
        #expect(go.tree.nodes[0].propertyValue(of: .komi) == 6.5)
    }

    @Test
    func noneProperty()  throws {
        let go = try Go(input: "(;FF[4](;B[ab]DO[];B[ba]))")
        
        let node1 = go.tree.nodes[0].children[0] // ;B[ab]DO[]
        #expect(node1.propertyValue(of: .doubtful) == SGFNone.none)
        #expect(node1.has(.doubtful))

        let node2 = node1.children[0] // ;B[ba]
        #expect(node2.propertyValue(of: .doubtful) == nil)
        #expect(!node2.has(.doubtful))
    }

    @Test
    func complexBranch()  throws {
        let input = "(;FF[4]C[root](;C[a];C[b](;C[c])(;C[d];C[e]))(;C[f](;C[g];C[h];C[i])(;C[j])))"
        let go = try Go(input: input)
        let tree = go.tree

        let rootNode = tree.nodes[0] // ";FF[4]C[root]"
        #expect(rootNode.propertyValue(of: .fileFormat) == 4)
        #expect(rootNode.propertyValue(of: .comment) == "root")
        #expect(rootNode.number == 0)
        #expect(rootNode.children.count == 2)
        #expect(rootNode.parent?.number == tree.number)

        let nodeA = rootNode.children[0] // ;C[a]
        #expect(nodeA.propertyValue(of: .comment) == "a")
        #expect(nodeA.children.count == 1)
        #expect(nodeA.number == 1)
        #expect(nodeA.parent?.number == rootNode.number)

        let nodeB = nodeA.children[0] // ;C[b]
        #expect(nodeB.propertyValue(of: .comment) == "b")
        #expect(nodeB.children.count == 2)
        #expect(nodeB.number == 2)
        #expect(nodeB.parent?.number == nodeA.number)

        let nodeC = nodeB.children[0] // ;C[c]
        #expect(nodeC.propertyValue(of: .comment) == "c")
        #expect(nodeC.children.count == 0)
        #expect(nodeC.number == 3)
        #expect(nodeC.parent?.number == nodeB.number)

        let nodeD = nodeB.children[1] // ;C[d]
        #expect(nodeD.propertyValue(of: .comment) == "d")
        #expect(nodeD.children.count == 1)
        #expect(nodeD.number == 4)
        #expect(nodeD.parent?.number == nodeB.number)

        let nodeE = nodeD.children[0] // ;C[e]
        #expect(nodeE.propertyValue(of: .comment) == "e")
        #expect(nodeE.children.count == 0)
        #expect(nodeE.number == 5)
        #expect(nodeE.parent?.number == nodeD.number)
    }

    @Test
    func inherit() throws {
        let go = try Go(input: "(;FF[4](;B[ab];B[ba]PM[3];B[c1]))")
        let node1 = go.tree.nodes[0].children[0] // ;B[ab]
        #expect(node1.propertyValue(of: .printMoveMode) == nil)

        let node2 = node1.children[0] // ;B[ba]PM[3]
        #expect(node2.propertyValue(of: .printMoveMode) == 3)

        let node3 = node2.children[0] // B[c1])
        #expect(node3.propertyValue(of: .printMoveMode) == 3)
    }

    @Test
    func convertToSGF() throws {
        let input = "(;FF[4]C[root](;C[a];C[b](;C[c])(;C[d];C[e]))(;C[f](;C[g];C[h];C[i])(;C[j])))"
        let go = try Go(input: input)
        #expect(go.tree.convertToSGF() == input)
    }

    @Test
    func convertToSGFWithEscaping() throws {
        let input = "(;FF[4]C[¥]¥:¥\\foo])"
        let go = try Go(input: input)
        #expect(go.tree.convertToSGF() == input)
    }
}
