import Foundation
import SwiftModule
import XCTest

class Tests: XCTestCase {
    func test() {
        XCTAssertEqual(moduleName, "SwiftModule")
        XCTAssertEqual(dependency1Name, "SwiftModule2")
    }
}
