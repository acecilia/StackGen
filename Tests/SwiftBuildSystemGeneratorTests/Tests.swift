import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

final class Tests: XCTestCase {
    func testClean() throws {
        for generator in Generator.allCases {
            let destination = try (generatorFixturesPath/generator.rawValue).copy(into: try tmp())

            FileManager.default.changeCurrentDirectoryPath(destination.string)
            let cli = SwiftBuildSystemGeneratorCLI()
            let status = cli.execute(with: cleanCommandArgs())
            XCTAssertEqual(status, 0)

            Snapshot.assert(destination, examplesPath, "Generator '\(generator)' failed")
        }
    }

    func testGenerate() throws {
        for generator in Generator.allCases {
            let destination = try examplesPath.copy(into: try tmp())

            FileManager.default.changeCurrentDirectoryPath(destination.string)
            let cli = SwiftBuildSystemGeneratorCLI()
            let status = cli.execute(with: generateCommandArgs(generator))
            XCTAssertEqual(status, 0)

            Snapshot.assert(destination, generatorFixturesPath/generator.rawValue, "Generator '\(generator)' failed")
        }
    }

    func testConverters() throws {
        for converter in Converter.allCases {
            switch converter {
            case .xcodegen:
                let destination = try (generatorFixturesPath/Generator.xcodegen.rawValue).copy(into: try tmp())
                FileManager.default.changeCurrentDirectoryPath(destination.string)

                do {
                    // Clean module.yml
                    let cli = SwiftBuildSystemGeneratorCLI()
                    let status = cli.execute(with: cleanCommandArgs(converter: .xcodegen))
                    XCTAssertEqual(status, 0)
                }

                do {
                    // Generate module.yml
                    let cli = SwiftBuildSystemGeneratorCLI()
                    let status = cli.execute(with: convertCommandArgs(.xcodegen))
                    XCTAssertEqual(status, 0)
                }

                do {
                    // Remove all xcodegen files
                    let cli = SwiftBuildSystemGeneratorCLI()
                    let status = cli.execute(with: cleanCommandArgs(generator: .xcodegen))
                    XCTAssertEqual(status, 0)
                }

                Snapshot.assert(destination, converterFixturesPath/converter.rawValue, "Converter '\(converter)' failed")
            }
        }

    }
}
