import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

final class FixtureGenerator: XCTestCase {
    func testGenerateFixtures() throws {
        for generator in Generator.allCases {
            try fixturesPath.mkdir(.p)
            let fixturePath = fixturesPath/generator.rawValue
            try fixturePath.delete()
            try examplesPath.copy(to: fixturePath)

            FileManager.default.changeCurrentDirectoryPath(fixturePath.string)
            let cli = SwiftBuildSystemGeneratorCLI()
            let status = cli.execute(with: generateCommandArgs(generator))
            XCTAssertEqual(status, 0)
        }
    }
}
