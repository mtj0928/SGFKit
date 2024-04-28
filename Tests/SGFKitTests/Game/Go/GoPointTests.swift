@testable import SGFKit
import XCTest

final class GoPointTests: XCTestCase {

    func testPoint() throws {
        let pointA = try GoPoint(value: "ab")
        XCTAssertEqual(pointA, GoPoint(column: 1, row: 2))

        let pointB = try GoPoint(value: "AZ")
        XCTAssertEqual(pointB, GoPoint(column: 27, row: 52))
    }
}

