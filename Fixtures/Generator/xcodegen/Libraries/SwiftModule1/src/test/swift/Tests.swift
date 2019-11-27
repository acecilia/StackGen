import Foundation
import SwiftModule
import SwiftModule3
import XCTest

class Tests: XCTestCase {
    func test() {
        let module3Name = SwiftModule3.moduleName

        XCTAssertEqual(SwiftModule.moduleName, "SwiftModule")
        XCTAssertEqual(module2Name, "SwiftModule2")
        XCTAssertEqual(fileKitName, "FileKit")
        XCTAssertEqual(module3Name, "SwiftModule3")
    }
}
