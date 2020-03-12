import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

final class Tests: XCTestCase {
    func testGenerate() throws {
        for templatesPath in templatesPath.ls().directories {
            let result = try generate(templatesPath)
            XCTAssertEqual(result.exitCode, 0)
            assert(fixture: fixturesPath/templatesPath.basename(), equals: result.destination)
        }
    }

    func testXcodegen() throws {
        let result = try generate(templatesPath/"xcodegen")
        XCTAssertEqual(result.exitCode, 0)

        // Generate Xcode projects
        let scriptOutput = runCommand("cd \(result.destination) && sh scripts/create-projects.sh")
        XCTAssertEqual(scriptOutput.exitCode, 0, scriptOutput.error.joined(separator: "\n"))

        // Run unit tests
        let xcodebuildOutput = runCommand("xcodebuild test -project \(result.destination)/All.xcodeproj -scheme All -destination 'platform=iOS Simulator,name=iPhone 8,OS=latest'")
        XCTAssertEqual(xcodebuildOutput.exitCode, 0, xcodebuildOutput.error.joined(separator: "\n"))
        if xcodebuildOutput.exitCode != 0 {
            runCommand("open \(result.destination)/All.xcodeproj")
        }
    }

    private func generate(_ templatesPath: Path, function: String = #function) throws -> (destination: Path, exitCode: Int32) {
        let destination = try examplesPath.copy(into: try tmp(testName: function))
        FileManager.default.changeCurrentDirectoryPath(destination.string)
        try patchWorkspaceFile(destination, using: templatesPath)

        let cli = SwiftBuildSystemGeneratorCLI()
        let exitCode = cli.execute(with: generateCommandArgs())

        return (destination: destination, exitCode: exitCode)
    }
}
