import XCTest
@testable import App

class Tests: XCTestCase {
    func test() {
        let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        let vc = window?.rootViewController as? MainViewController
        XCTAssertEqual(vc?.view.backgroundColor, .red)
    }
}

