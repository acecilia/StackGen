import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

final class FixtureGenerator: XCTestCase {
    func testGenerateXcodeGenFixture() throws {
        try fixturesPath.mkdir(.p)
        let xcodeGenFixturePath = fixturesPath/GeneratorType.XcodeGen.rawValue
        try xcodeGenFixturePath.delete()
        try examplesPath.copy(to: xcodeGenFixturePath)

        FileManager.default.changeCurrentDirectoryPath(xcodeGenFixturePath.string)
        let cli = SwiftBuildSystemGeneratorCLI()
        let status = cli.execute(with: generateCommandArgs)
        XCTAssertEqual(status, 0)
    }
}
