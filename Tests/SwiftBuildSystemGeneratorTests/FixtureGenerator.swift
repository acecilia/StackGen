import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

final class FixtureGenerator: XCTestCase {
    func testGenerateFixtures() throws {
        try fixturesPath.delete()

        for generator in Generator.allCases {
            let fixturePath = fixturesPath/"\(Generator.self)"
            try fixturePath.mkdir(.p)
            let outputPath = fixturePath/generator.rawValue
            try outputPath.delete()
            try examplesPath.copy(to: outputPath)

            FileManager.default.changeCurrentDirectoryPath(outputPath.string)
            let cli = SwiftBuildSystemGeneratorCLI()
            let args = generateCommandArgs(generator)
            let status = cli.execute(with: args)
            XCTAssertEqual(status, 0)
        }
    }

    private func defaultGenerate() {

    }
}
