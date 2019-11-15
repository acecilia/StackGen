import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

final class FixtureGenerator: XCTestCase {
    func testGenerateXcodeGenFixture() throws {
        let xcodeGenFixturePath = fixturesPath/Generator.XcodeGen.rawValue
        try xcodeGenFixturePath.delete()
        try examplesPath.copy(to: xcodeGenFixturePath)

        FileManager.default.changeCurrentDirectoryPath(xcodeGenFixturePath.string)
        let cli = SwiftBuildSystemGeneratorCLI()
        cli.execute(with: generateCommandArgs)
    }
}
