@testable import SGFKit
import Testing

@Suite
struct PropertyTests {

    @Test
    func propertyInitializerWithMove() throws {
        let point = GoPoint(column: 3, row: 3)
        let definition: PropertyDefinition<Go, GoPoint> = .black
        let property = Property(definition, value: point)

        #expect(property.identifier == "B")
        #expect(property.values == [.single("cc")])
    }

    @Test
    func propertyInitializerWithText() throws {
        let comment = "This is a test comment"
        let definition: PropertyDefinition<Go, String> = .comment
        let property = Property(definition, value: comment)

        #expect(property.identifier == "C")
        #expect(property.values == [.single(comment)])
    }

    @Test
    func propertyInitializerWithNumber() throws {
        let fileFormat = 4
        let definition: PropertyDefinition<Go, Int> = .fileFormat
        let property = Property(definition, value: fileFormat)

        #expect(property.identifier == "FF")
        #expect(property.values == [.single("4")])
    }

    @Test
    func propertyInitializerWithList() throws {
        let go = try Go(input: "(;FF[4];B[ab];B[ba])")
        let rootNode = go.tree.nodes[0]
        let node = rootNode.children[0]

        let point = GoPoint(column: 3, row: 3)
        let definition: PropertyDefinition<Go, GoPoint> = .black
        let newNode = Node<Go>(properties: [Property(definition, value: point)])
        node.children.append(newNode)

        #expect(go.tree.convertToSGF() == "(;FF[4];B[ab](;B[ba])(;B[cc]))")
    }
}
