import XCTest
import BuildSystemGeneratorCLI
import BuildSystemGeneratorKit
import Path
import Foundation

// These tests are only used during development. Control if they are enabled with the macro below
#if false
typealias DevelomentTestCase = XCTestCase
#else
typealias DevelomentTestCase = NSObject
#endif

final class DevelopmentTests: DevelomentTestCase {
    func testRun() throws {
        let result = try generate(using: .Swift_BuildSystem_Bazel)
        runCommand("""
        osascript -e 'tell application "Terminal" to do script "cd \(result.destination); source taskfile; setup"'
        osascript -e 'tell application "Terminal"' -e 'activate' -e 'end tell'
        """)
        XCTAssertEqual(0, 1)
    }
}
