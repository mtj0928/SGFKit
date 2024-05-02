# SGFKit
A library for operating [SGF FF[4]](https://www.red-bean.com/sgf/index.html) file in Swift.
You can manipulate SGF in type-safe manner.

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
