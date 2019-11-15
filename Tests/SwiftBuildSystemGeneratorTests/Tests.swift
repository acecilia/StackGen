import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

final class Tests: XCTestCase {
    func testClean() throws {
        let destination = try (fixturesPath/Generator.XcodeGen.rawValue).copy(into: try tmp())

        FileManager.default.changeCurrentDirectoryPath(destination.string)
        let cli = SwiftBuildSystemGeneratorCLI()
        cli.execute(with: [CleanCommand.name])

        let result = FileManager.default.contentsEqual(
            atPath: destination.string,
            andPath: examplesPath.string
        )
        XCTAssertTrue(result)
    }

    func testGenerate() throws {
        let destination = try examplesPath.copy(into: try tmp())

        FileManager.default.changeCurrentDirectoryPath(destination.string)
        let cli = SwiftBuildSystemGeneratorCLI()
        cli.execute(with: generateCommandArgs)

        let result = FileManager.default.contentsEqual(
            atPath: destination.string,
            andPath: (fixturesPath/Generator.XcodeGen.rawValue).string
        )
        XCTAssertTrue(result)
    }

}
