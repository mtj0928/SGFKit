extension Collection {
    
    /// Converts the collection to a SGF text.
    public func convertToSGF() -> String {
        convertToNonTerminalSymbol().convertToSGF()
    }
    
    /// Converts the collection to non terminal symbols.
    public func convertToNonTerminalSymbol() -> NonTerminalSymbols.Collection {
        let gameTrees = nodes.map { gameTree(from: $0) }
        return NonTerminalSymbols.Collection(gameTrees: gameTrees)
    }

    private func gameTree(from node: Node<Game>) -> NonTerminalSymbols.GameTree {
        var sequenceNodes: [NonTerminalSymbols.Node] = []
        var currentNode = node

        while true {
            let node = convertToNode(from: currentNode)
            sequenceNodes.append(node)
            if currentNode.children.isEmpty {
                return NonTerminalSymbols.GameTree(
                    sequence: NonTerminalSymbols.Sequence(nodes: sequenceNodes),
                    gameTrees: []
                )
            }
            else if currentNode.children.count == 1 {
                currentNode = currentNode.children[0]
            } else {
                break
            }
        }

        let gameTrees = currentNode.children.map { gameTree(from: $0) }

        return NonTerminalSymbols.GameTree(
            sequence: NonTerminalSymbols.Sequence(nodes: sequenceNodes),
            gameTrees: gameTrees
        )
    }

    private func convertToNode(from node: Node<Game>) -> NonTerminalSymbols.Node {
        let properties = node.properties.map { property in
            convertToProperty(from: property)
        }

        return NonTerminalSymbols.Node(properties: properties)
    }

    private func convertToProperty(from property: Property) -> NonTerminalSymbols.Property {
        let values = property.values.map { value in convertToPropValue(from: value) }
        return NonTerminalSymbols.Property(
            identifier: NonTerminalSymbols.PropIdent(letters: property.identifier),
            values: values
        )
    }

    private func convertToPropValue(from value: Compose) -> NonTerminalSymbols.PropValue {
        switch value {
        case .single(let value):
            return NonTerminalSymbols.PropValue(type: .single(value.flatMap({ NonTerminalSymbols.ValueType($0) })))
        case .compose(let valueA, let valueB):
            return NonTerminalSymbols.PropValue(type: .compose(
                valueA.map { NonTerminalSymbols.ValueType($0) },
                valueB.map { NonTerminalSymbols.ValueType($0) }
            ))
        }
    }
}
