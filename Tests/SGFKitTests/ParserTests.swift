@testable import SGFKit
import XCTest

final class GoParserTests: XCTestCase {

    func testParseForSimpleCase() throws {
        let input = """
        (;FF[4]C[root](;C[a];C[b](;C[c])
        (;C[d];C[e]))
        (;C[f](;C[g];C[h];C[i])
        (;C[j])))
        """
        let collection = try Parser.parse(input: input)

        let expected = SGFNodes.Collection(
            gameTrees: [
                SGFNodes.GameTree(
                    sequence: SGFNodes.Sequence(nodes: [
                        SGFNodes.Node(properties: [
                            SGFNodes.Property(identifier: "FF", values: [SGFNodes.PropValue(type: .single("4"))]),
                            SGFNodes.Property(identifier: "C", values: [SGFNodes.PropValue(type: .single("root"))])
                        ]),
                    ]),
                    gameTrees: [
                        SGFNodes.GameTree(
                            sequence: SGFNodes.Sequence(nodes: [
                                SGFNodes.Node(properties: [
                                    SGFNodes.Property(
                                        identifier: "C",
                                        values: [SGFNodes.PropValue(type: .single("a"))]
                                    )
                                ]),
                                SGFNodes.Node(properties: [
                                    SGFNodes.Property(
                                        identifier: "C",
                                        values: [SGFNodes.PropValue(type: .single("b"))]
                                    )
                                ])
                            ]),
                            gameTrees: [
                                SGFNodes.GameTree(
                                    sequence: SGFNodes.Sequence(nodes: [
                                        SGFNodes.Node(
                                            properties: [SGFNodes.Property(identifier: "C", values: [SGFNodes.PropValue(type: .single("c"))])]
                                        )
                                    ]),
                                    gameTrees: []
                                ),
                                SGFNodes.GameTree(
                                    sequence: SGFNodes.Sequence(nodes: [
                                        SGFNodes.Node(properties: [SGFNodes.Property(identifier: "C", values: [SGFNodes.PropValue(type: .single("d"))])]),
                                        SGFNodes.Node(properties: [SGFNodes.Property(identifier: "C", values: [SGFNodes.PropValue(type: .single("e"))])])
                                    ]), gameTrees: [])

                            ]
                        ),
                        SGFNodes.GameTree(
                            sequence: SGFNodes.Sequence(nodes: [
                                SGFNodes.Node(properties: [SGFNodes.Property(identifier: "C", values: [SGFNodes.PropValue(type: .single("f"))])])
                            ]),
                            gameTrees: [
                                SGFNodes.GameTree(
                                    sequence: SGFNodes.Sequence(nodes: [
                                        SGFNodes.Node(properties: [SGFNodes.Property(identifier: "C", values: [SGFNodes.PropValue(type: .single("g"))])]),
                                        SGFNodes.Node(properties: [SGFNodes.Property(identifier: "C", values: [SGFNodes.PropValue(type: .single("h"))])]),
                                        SGFNodes.Node(properties: [SGFNodes.Property(identifier: "C", values: [SGFNodes.PropValue(type: .single("i"))])])
                                    ]),
                                    gameTrees: []
                                ),
                                SGFNodes.GameTree(
                                    sequence: SGFNodes.Sequence(nodes: [
                                        SGFNodes.Node(properties: [SGFNodes.Property(identifier: "C", values: [SGFNodes.PropValue(type: .single("j"))])])
                                    ]),
                                    gameTrees: []
                                )
                            ]
                        )
                    ]
                )
            ]
        )
        XCTAssertEqual(collection, expected)
    }

    func testString() throws {
        let input = """
        (;FF[4]C[root](;C[a];C[b](;C[c])
        (;C[d];C[e]))
        (;C[f](;C[g];C[h];C[i])
        (;C[j])))
        """
        let collection = try Parser.parse(input: input)

        XCTAssertEqual(
            collection.string(),
            "(;FF[4]C[root](;C[a];C[b](;C[c])(;C[d];C[e]))(;C[f](;C[g];C[h];C[i])(;C[j])))"
        )
    }
}
