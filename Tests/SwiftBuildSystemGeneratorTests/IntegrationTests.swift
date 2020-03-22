import XCTest
import SwiftBuildSystemGeneratorKit
import Path

final class IntegrationTests: XCTestCase {
    func testXcodegen() throws {
        // Generate XcodeGen files
        let result = try generate(using: templatesPath/"xcodegen")
        XCTAssertEqual(result.exitCode, 0)

        // Generate Xcode projects
        let scriptOutput = runCommand("cd \(result.destination); sh scripts/create-projects.sh")
        XCTAssertEqual(scriptOutput.exitCode, 0, scriptOutput.error.joined(separator: "\n"))

        // Run unit tests
        xcodebuildTestAll(result.destination)
    }

    func testCocoapods() throws {
        // Generate cocoapods files
        let result = try generate(using: templatesPath/"cocoapods")
        XCTAssertEqual(result.exitCode, 0)

        // Generate Xcode projects
        let scriptOutput = runCommand("cd \(result.destination); sh scripts/setup.sh")
        XCTAssertEqual(scriptOutput.exitCode, 0, scriptOutput.error.joined(separator: "\n"))

        // Run unit tests
        xcodebuildTestAll(result.destination)
    }

    private func xcodebuildTestAll(_ path: Path) {
        let xcodebuildOutput = runCommand("xcodebuild test -project \(path)/All.xcodeproj -scheme All -destination 'platform=iOS Simulator,name=iPhone 8,OS=latest'")
        XCTAssertEqual(xcodebuildOutput.exitCode, 0, xcodebuildOutput.error.joined(separator: "\n"))
        if xcodebuildOutput.exitCode != 0 {
            runCommand("open \(path)/All.xcodeproj")
        }
    }
}
