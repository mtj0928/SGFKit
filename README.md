# SGFKit
A library for persing [SGF FF[4]](https://www.red-bean.com/sgf/index.html) file in Swift.

## Usage
```swift
let input = "(;FF[4]C[root](;C[a];C[b](;C[c])(;C[d];C[e]))(;C[f](;C[g];C[h];C[i])(;C[j])))"

let collection = try Parser.parse(input: input)
let firstNode = collection.gameTrees[0].sequence.nodes[0]
let firstProperty = firstNode.properties[0]

print("id: \(firstProperty.identifier.letters)") // id: FF
print("value: \(firstProperty.values[0].type.first.value ?? "none")") // value: ValueType(value: "4")
```