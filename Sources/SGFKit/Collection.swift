/// A collection of SGF nodes.
public final class Collection<Game: SGFKit.Game> {

    /// Nodes in the first depth of the collection.
    /// > Note: SGF can have multiple root nodes.
    public var nodes: [Node<Game>] { didSet { refreshStructure() } }
    
    /// Makes a collection.
    /// - Parameter nodes: Nodes in the first depth of the collection.
    public init(nodes: [Node<Game>]) {
        self.nodes = nodes
        refreshStructure()
    }

    private func refreshStructure() {
        let numberPublisher = NumberPublisher()
        for node in nodes {
            node.parent = self
            refreshNumber(of: node, numberPublisher: numberPublisher)
        }
    }

    private func refreshNumber(of node: Node<Game>, numberPublisher: NumberPublisher) {
        node.number = numberPublisher.publish()
        for child in node.children {
            child.parent = node
            refreshNumber(of: child, numberPublisher: numberPublisher)
        }
    }
    
    /// Makes the copy of the collection.
    public func copy() -> Collection<Game> {
        let copiedNodes = nodes.map { $0.copy() }
        return Collection(nodes: copiedNodes)
    }
}

extension Collection: NodeProtocol {
    var number: Int? {
        -1
    }

    func propertyValue<Value: PropertyValue>(of definition: PropertyDefinition<Game, Value>) -> Value? {
        nil
    }

    func node(treeStructureDidUpdated number: Int?) {
        refreshStructure()
    }

    public static func == (lhs: Collection<Game>, rhs: Collection<Game>) -> Bool {
        lhs.nodes == rhs.nodes
    }
}

private final class NumberPublisher {
    private var currentID = 0

    func publish() -> Int {
        let result = currentID
        currentID += 1
        return result
    }
}
