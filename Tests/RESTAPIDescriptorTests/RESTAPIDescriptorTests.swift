import XCTest
@testable import RESTAPIDescriptor

final class RESTAPIDescriptorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RESTAPIDescriptor().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
