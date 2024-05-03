public final class Collection<Game: SGFKit.Game>  {
    // SGF can have multiple root nodes.
    public var nodes: [Node<Game>] { didSet { refreshStructure() } }

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

    public func copy() -> Collection<Game> {
        let collection = Collection<Game>(nodes: [])
        let nods = nodes.map { $0.copy() }
        collection.nodes = nodes
        return collection
    }
}

extension Collection: NodeDelegate {
    public var number: Int? {
        -1
    }

    public func propertyValue<Value: PropertyValue>(of definition: PropertyDefinition<Game, Value>) -> Value? {
        nil
    }

    public func node(treeStructureDidUpdated number: Int?) {
        refreshStructure()
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
