import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

final class Tests: XCTestCase {
    func testGenerate() throws {
        for templatesPath in templatesPath.ls().directories {
            let result = try generate(templatesPath)
            XCTAssertEqual(result.status, 0)
            assert(fixture: fixturesPath/templatesPath.basename(), equals: result.destination)
        }
    }

    private func generate(_ templatesPath: Path, function: String = #function) throws -> (destination: Path, status: Int32) {
        let destination = try examplesPath.copy(into: try tmp(testName: function))
        FileManager.default.changeCurrentDirectoryPath(destination.string)
        try patchWorkspaceFile(destination, using: templatesPath)

        let cli = SwiftBuildSystemGeneratorCLI()
        let status = cli.execute(with: generateCommandArgs())

        return (destination: destination, status: status)
    }
}
