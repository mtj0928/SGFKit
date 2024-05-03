#  Parsing and reading a SGF file in a type-safe manner
Parse and read a SGF file in a type-safe manner.

## Overview
In this article, you'll learn how to parse and read a SGF file in a type-safe manner.
This document shows examples for Go, but the way can be applied to another game too.

### Parse a SGF file
By just calling the `init` of a `Game` protocol, you can parse the SGF text.
The `init` can throw ``LexerError`` or ``ParserError``, and please catch an error based on your requirement.

```swift
let go = try Go(input: "(;FF[4]C[root](;B[ab]))")
```

### Get a node.
``Game`` protocol has `tree`, and it has nodes of the game. 
The nodes are tree structure.
According to [the official documents](https://www.red-bean.com/sgf/sgf4.html#1), the first node shows a main line of the game 
and the other lines are variations.

```swift
let go = try Go(input: "(;FF[4]C[root](;B[ab]))")
let rootNode = go.tree.nodes[0] // ;FF[4]C[root]
let nodeA = rootNode.children[0] // ;B[ab]
```

### Get a property value
A node has properties and you can get a property value in a type-safe manner by `propertyValue(of:)`.
The function receives a ``PropertyDefinition``, and the general value are pre-defined like `fileFormat` and `comment`.

```swift
let go = try Go(input: "(;FF[4]C[root](;B[ab]))")
let rootNode = go.tree.nodes[0] // ;FF[4]C[root]
let fileFormatVersion: Int? = rootNode.propertyValue(of: .fileFormat) // 4
let comment: String? = rootNode.propertyValue(of: .comment) // "root"
```
