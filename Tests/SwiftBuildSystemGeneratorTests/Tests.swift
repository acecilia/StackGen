import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

final class Tests: XCTestCase {
    func testGenerate() throws {
        for templatesPath in templatesPath.ls().directories {
            let templatesName = templatesPath.basename()

            let destination = try examplesPath.copy(into: try tmp())
            try patchWorkspaceFile(destination, using: templatesPath)

            FileManager.default.changeCurrentDirectoryPath(destination.string)
            let cli = SwiftBuildSystemGeneratorCLI()
            let status = cli.execute(with: generateCommandArgs())
            XCTAssertEqual(status, 0)

            assert(fixturesPath/templatesName, destination, "Template '\(templatesName)' failed")
        }
    }
}
