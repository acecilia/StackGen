/*
// This tests are only used during development

import XCTest
import BuildSystemGeneratorCLI
import BuildSystemGeneratorKit
import Path
import Foundation

final class DevelopmentTests: XCTestCase {
    func testRun() throws {
        let path = templatesPath/"xcodegen"
        let result = try generate(using: path)
        runCommand("""
        osascript -e 'tell application "Terminal" to do script "cd \(result.destination); source taskfile; setup; test"'
        osascript -e 'tell application "Terminal"' -e 'activate' -e 'end tell'
        """)
        XCTAssertEqual(0, 1)
    }
}

// */
