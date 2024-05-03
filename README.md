# SGFKit
SGFKit is a library for operating a [SGF FF[4]](https://www.red-bean.com/sgf/index.html) file in Swift.
You can manipulate a SGF in a type-safe manner.

Please refer [documents](https://mtj0928.github.io/SGFKit/documentation/sgfkit).

## Install
SGFKit supports only Swift Package Manager.
```swift
.package(url: "https://github.com/mtj0928/SGFKit", .upToNextMinor(from: "0.4.0"))
```

## Usage

### Parse String for a specific Game.
You can extract a property from the SGF in the type-safe manner, when the game is specified, 
```swift
let go = try Go(input: "(;FF[4]C[root](;B[ab]))")

let rootNode = go.tree.nodes[0] // ;FF[4]C[root]
let fileFormatVersion: Int? = rootNode.propertyValue(of: .fileFormat) // 4
let comment: String? = rootNode.propertyValue(of: .comment) // "root"

let nodeA = rootNode.children[0] // ;B[ab]
let pointA: Go.Point? = nodeA.propertyValue(of: .black) // (1, 2)
```

### Parse String as plain SGF.
You can parse the SGF based on [the official EBNF](https://www.red-bean.com/sgf/sgf4.html#ebnf-def).

```swift
let input = "(;FF[4]C[root](;C[a];C[b](;C[c])(;C[d];C[e]))(;C[f](;C[g];C[h];C[i])(;C[j])))"

let collection = try Parser.parse(input: input)
let firstNode = collection.gameTrees[0].sequence.nodes[0] // ;FF[4]C[root]
let firstProperty = firstNode.properties[0] // FF[4]

print(firstProperty.identifier.letters) // "FF"
print(firstProperty.values[0].type.first.value ?? "none") // "4"
```

### Update a property
You can update a property value and remove a property from a node.

> [!NOTE]
> A node is a reference type due to a tree structure.

```swift
let go = try Go(input: "(;FF[4];B[ab]C[a];B[ba])")
let rootNode = go.tree.nodes[0]
let node = rootNode.children[0] // ;B[ab]C[a]

let point = GoPoint(column: 4, row: 3)
node.addProperty(point, to: .black) // dc
node.removeProperty(of: .comment)

print(go.tree.convertToSGF()) // "(;FF[4];B[dc];B[ba])"
```
