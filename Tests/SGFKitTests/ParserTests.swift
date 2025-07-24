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

        let expected = NonTerminalSymbols.Collection(
            gameTrees: [
                NonTerminalSymbols.GameTree(
                    sequence: NonTerminalSymbols.Sequence(nodes: [
                        NonTerminalSymbols.Node(properties: [
                            NonTerminalSymbols.Property(identifier: "FF", values: [NonTerminalSymbols.PropValue(type: .single("4"))]),
                            NonTerminalSymbols.Property(identifier: "C", values: [NonTerminalSymbols.PropValue(type: .single("root"))])
                        ]),
                    ]),
                    gameTrees: [
                        NonTerminalSymbols.GameTree(
                            sequence: NonTerminalSymbols.Sequence(nodes: [
                                NonTerminalSymbols.Node(properties: [
                                    NonTerminalSymbols.Property(
                                        identifier: "C",
                                        values: [NonTerminalSymbols.PropValue(type: .single("a"))]
                                    )
                                ]),
                                NonTerminalSymbols.Node(properties: [
                                    NonTerminalSymbols.Property(
                                        identifier: "C",
                                        values: [NonTerminalSymbols.PropValue(type: .single("b"))]
                                    )
                                ])
                            ]),
                            gameTrees: [
                                NonTerminalSymbols.GameTree(
                                    sequence: NonTerminalSymbols.Sequence(nodes: [
                                        NonTerminalSymbols.Node(
                                            properties: [NonTerminalSymbols.Property(identifier: "C", values: [NonTerminalSymbols.PropValue(type: .single("c"))])]
                                        )
                                    ]),
                                    gameTrees: []
                                ),
                                NonTerminalSymbols.GameTree(
                                    sequence: NonTerminalSymbols.Sequence(nodes: [
                                        NonTerminalSymbols.Node(properties: [NonTerminalSymbols.Property(identifier: "C", values: [NonTerminalSymbols.PropValue(type: .single("d"))])]),
                                        NonTerminalSymbols.Node(properties: [NonTerminalSymbols.Property(identifier: "C", values: [NonTerminalSymbols.PropValue(type: .single("e"))])])
                                    ]), gameTrees: [])

                            ]
                        ),
                        NonTerminalSymbols.GameTree(
                            sequence: NonTerminalSymbols.Sequence(nodes: [
                                NonTerminalSymbols.Node(properties: [NonTerminalSymbols.Property(identifier: "C", values: [NonTerminalSymbols.PropValue(type: .single("f"))])])
                            ]),
                            gameTrees: [
                                NonTerminalSymbols.GameTree(
                                    sequence: NonTerminalSymbols.Sequence(nodes: [
                                        NonTerminalSymbols.Node(properties: [NonTerminalSymbols.Property(identifier: "C", values: [NonTerminalSymbols.PropValue(type: .single("g"))])]),
                                        NonTerminalSymbols.Node(properties: [NonTerminalSymbols.Property(identifier: "C", values: [NonTerminalSymbols.PropValue(type: .single("h"))])]),
                                        NonTerminalSymbols.Node(properties: [NonTerminalSymbols.Property(identifier: "C", values: [NonTerminalSymbols.PropValue(type: .single("i"))])])
                                    ]),
                                    gameTrees: []
                                ),
                                NonTerminalSymbols.GameTree(
                                    sequence: NonTerminalSymbols.Sequence(nodes: [
                                        NonTerminalSymbols.Node(properties: [NonTerminalSymbols.Property(identifier: "C", values: [NonTerminalSymbols.PropValue(type: .single("j"))])])
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

    func testConvertToSGF() throws {
        let input = """
        (;FF[4]C[root](;C[a];C[b](;C[c])
        (;C[d];C[e]))
        (;C[f](;C[g];C[h];C[i])
        (;C[j])))
        """
        let collection = try Parser.parse(input: input)

        XCTAssertEqual(
            collection.convertToSGF(),
            "(;FF[4]C[root](;C[a];C[b](;C[c])(;C[d];C[e]))(;C[f](;C[g];C[h];C[i])(;C[j])))"
        )
    }
}
