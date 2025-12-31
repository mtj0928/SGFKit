@testable import SGFKit
import Testing

@Suite
struct NodeTests {

    // MARK: - Equatable Tests

    @Test
    func equalityWithSameProperties() throws {
        let property1 = Property(identifier: "B", values: [.single("cc")])
        let node1 = Node<Go>(properties: [property1])

        let property2 = Property(identifier: "B", values: [.single("cc")])
        let node2 = Node<Go>(properties: [property2])

        #expect(node1 == node2)
    }

    @Test
    func equalityWithDifferentProperties() throws {
        let property1 = Property(identifier: "B", values: [.single("cc")])
        let node1 = Node<Go>(properties: [property1])

        let property2 = Property(identifier: "B", values: [.single("dd")])
        let node2 = Node<Go>(properties: [property2])

        #expect(node1 != node2)
    }

    @Test
    func equalityWithDifferentNumbers() throws {
        let property1 = Property(identifier: "B", values: [.single("cc")])
        let node1 = Node<Go>(number: 1, properties: [property1])

        let property2 = Property(identifier: "B", values: [.single("cc")])
        let node2 = Node<Go>(number: 2, properties: [property2])

        #expect(node1 != node2)
    }

    @Test
    func equalityWithSameChildren() throws {
        let childProperty1 = Property(identifier: "W", values: [.single("dd")])
        let child1 = Node<Go>(properties: [childProperty1])

        let property1 = Property(identifier: "B", values: [.single("cc")])
        let node1 = Node<Go>(properties: [property1])
        node1.children = [child1]

        let childProperty2 = Property(identifier: "W", values: [.single("dd")])
        let child2 = Node<Go>(properties: [childProperty2])

        let property2 = Property(identifier: "B", values: [.single("cc")])
        let node2 = Node<Go>(properties: [property2])
        node2.children = [child2]

        #expect(node1 == node2)
    }

    @Test
    func equalityWithDifferentChildren() throws {
        let childProperty1 = Property(identifier: "W", values: [.single("dd")])
        let child1 = Node<Go>(properties: [childProperty1])

        let property1 = Property(identifier: "B", values: [.single("cc")])
        let node1 = Node<Go>(properties: [property1])
        node1.children = [child1]

        let childProperty2 = Property(identifier: "W", values: [.single("ee")])
        let child2 = Node<Go>(properties: [childProperty2])

        let property2 = Property(identifier: "B", values: [.single("cc")])
        let node2 = Node<Go>(properties: [property2])
        node2.children = [child2]

        #expect(node1 != node2)
    }

    @Test
    func equalityWithDifferentChildrenCount() throws {
        let childProperty1 = Property(identifier: "W", values: [.single("dd")])
        let child1 = Node<Go>(properties: [childProperty1])

        let property1 = Property(identifier: "B", values: [.single("cc")])
        let node1 = Node<Go>(properties: [property1])
        node1.children = [child1]

        let property2 = Property(identifier: "B", values: [.single("cc")])
        let node2 = Node<Go>(properties: [property2])

        #expect(node1 != node2)
    }
}
