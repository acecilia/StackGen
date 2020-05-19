import XCTest
@testable import App

class Tests: XCTestCase {
    func test() {
        let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        let vc = window?.rootViewController as? MainViewController
        XCTAssertEqual(vc?.view.backgroundColor, .red)

        XCTAssertEqual(vc?.moduleName, "App")
        XCTAssertEqual(vc?.module1Name, "SwiftModule1")
        XCTAssertEqual(vc?.module2Name, "SwiftModule2")
        XCTAssertEqual(vc?.snapKitName, "SnapKit")
        XCTAssertEqual(vc?.module3Name, "SwiftModule3")
    }
}

