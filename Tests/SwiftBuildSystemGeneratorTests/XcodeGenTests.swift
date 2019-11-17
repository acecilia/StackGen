import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

final class XcodeGenTests: XCTestCase {
    func testClean() throws {
        let destination = try (fixturesPath/GeneratorType.XcodeGen.rawValue).copy(into: try tmp())

        FileManager.default.changeCurrentDirectoryPath(destination.string)
        let cli = SwiftBuildSystemGeneratorCLI()
        let status = cli.execute(with: [CleanCommand.name])
        XCTAssertEqual(status, 0)

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
        let status = cli.execute(with: generateCommandArgs)
        XCTAssertEqual(status, 0)

        let result = FileManager.default.contentsEqual(
            atPath: destination.string,
            andPath: (fixturesPath/GeneratorType.XcodeGen.rawValue).string
        )
        XCTAssertTrue(result)
    }

}
