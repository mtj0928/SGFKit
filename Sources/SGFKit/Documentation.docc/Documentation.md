# ``SGFKit``

A library which can manipulates a [SGF FF[4]](https://www.red-bean.com/sgf/index.html) file in Swift.

## Overview

SGFKit is a library which can manipulates SGF in Swift in a type-safe manner.

```swift
// Parse a text in SGF.
let go = try Go(input: "(;FF[4]C[root](;B[ab]))")

// Get a root node and read the properties.
let rootNode = go.tree.nodes[0] // ;FF[4]C[root]
let fileFormatVersion: Int? = rootNode.propertyValue(of: .fileFormat) // 4
let comment: String? = rootNode.propertyValue(of: .comment) // "root"

// Get a node, and read and update the properties.
let nodeA = rootNode.children[0] // ;B[ab]
let pointA: Go.Point? = nodeA.propertyValue(of: .black) // (1, 2)
nodeA.addProperty("comment", to: .comment) // ;B[ab]C[comment]

// Convert the tress to a text in SGF.
print(go.tree.convertToSGF) // "(;FF[4]C[root](;B[ab]C[comment]))"
```

## Topics

### Essentials
- <doc:Parsing-and-reading-a-SGF-file-in-a-type-safe-manner>
- <doc:Updating-and-writing-a-SGF-file-in-a-type-safe-manner>
