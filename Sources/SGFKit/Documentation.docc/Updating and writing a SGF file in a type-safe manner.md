# Updating and Writing a SGF file in a type-safe manner
Update and write a SGF file in a type-safe manner.

## Overview
In this article, you'll learn how to update and write a SGF file in a type-safe manner.
This document shows examples for Go, but the way can be applied to another game too.

### Update a property value.
By calling `addProperty(_,to:)`, you can add or update the property to the given value.
And, you can remove the property by `removeProperty(of:)`
```swift
let go = try Go(input: "(;FF[4](;B[ab]))")
let rootNode = go.tree.nodes[0] // ;FF[4]
rootNode.addProperty("Foo", to: .comment) // ;FF[4]C[Foo]
rootNode.addProperty("Bar", to: .comment) // ;FF[4]C[Bar]
rootNode.removeProperty(of: .comment) // ;FF[4]
```

### Writing a SGF file 
You can convert the collection to a text in SGF by calling `convertToSGF()`.

```swift
let go = try Go(input: "(;FF[4](;B[ab]))")
let rootNode = go.tree.nodes[0] // ;FF[4]
rootNode.addProperty("Foo", to: .comment) // ;FF[4]C[Foo]
print(go.tree.convertToSGF()) // "(;FF[4]C[Foo](;B[ab]))"
```

> Note: ``Collection`` and ``Node`` are reference types. If you don't want to update the original collection, please use `copy()`.
