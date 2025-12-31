@testable import SGFKit
import Testing

@Suite
struct GoCollectionTests {

    @Test
    func addProperty() throws {
        let go = try Go(input: "(;FF[4];B[ab];B[ba])")
        let rootNode = go.tree.nodes[0]
        let node = rootNode.children[0] // ;B[ab]

        let point = GoPoint(column: 2, row: 28)
        node.addProperty(point, to: .black) // bB
        #expect(node.propertyValue(of: .black) == point)

        #expect(go.tree.convertToSGF() == "(;FF[4];B[bB];B[ba])")
    }

    @Test
    func removeProperty() throws {
        let go = try Go(input: "(;FF[4];B[ab]C[a];B[ba])")
        let rootNode = go.tree.nodes[0]
        let node = rootNode.children[0] // ;B[ab]C[a]
        #expect(node.propertyValue(of: .comment) == "a")

        node.removeProperty(of: .comment)
        #expect(node.propertyValue(of: .comment) == nil)
        #expect(!node.has(.comment))
        #expect(go.tree.convertToSGF() == "(;FF[4];B[ab];B[ba])")
    }

    @Test
    func addNewNode() throws {
        let go = try Go(input: "(;FF[4];B[ab];B[ba])")
        let rootNode = go.tree.nodes[0]
        let node = rootNode.children[0] // ;B[ab]
        node.children.append(Node(properties: [Property(identifier: "B", values: [.single("cc")])]))

        #expect(go.tree.nodes[0].number == 0)
        #expect(go.tree.nodes[0].children[0].number == 1)
        #expect(go.tree.nodes[0].children[0].children[0].number == 2)
        #expect(go.tree.nodes[0].children[0].children[1].number == 3)
        #expect(go.tree.convertToSGF() == "(;FF[4];B[ab](;B[ba])(;B[cc]))")
    }

    @Test
    func removeNode() throws {
        let go = try Go(input: "(;FF[4];B[ab];B[ba])")
        let rootNode = go.tree.nodes[0]
        let node = rootNode.children[0] // ;B[ab]
#if compiler(>=6.2)
        weak let childNode = node.children.first // ;B[ba]
#else
        weak var childNode = node.children.first // ;B[ba]
#endif
        node.children.removeAll()

        #expect(go.tree.nodes[0].number == 0)
        #expect(go.tree.nodes[0].children[0].number == 1)
        #expect(go.tree.convertToSGF() == "(;FF[4];B[ab])")
        #expect(childNode == nil)
    }

    @Test
    func copyNode() throws {
        let go = try Go(input: "(;FF[4];B[ab];B[ba])")
        let rootNode = go.tree.nodes[0]
        let node = rootNode.children[0] // ;B[ab]

        let copiedNode = node.copy()
        #expect(copiedNode !== node)
        #expect(copiedNode.propertyValue(of: .black) == GoPoint(column: 1, row: 2))
        #expect(copiedNode.children[0].propertyValue(of: .black) == GoPoint(column: 2, row: 1))
    }

    @Test
    func copyCollection() throws {
        let go = try Go(input: "(;FF[4];B[ab];B[ba])")
        let collection = go.tree
        let copiedCollection = collection.copy()

        #expect(copiedCollection !== collection)
        #expect(copiedCollection.convertToSGF() == "(;FF[4];B[ab];B[ba])")
    }
}
