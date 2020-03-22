import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

final class Generator: XCTestCase {
    func testSelfGenerate() throws {
        let path = rootPath
        FileManager.default.changeCurrentDirectoryPath(path.string)

        let cli = SwiftBuildSystemGeneratorCLI()
        let exitCode = cli.execute(with: [GenerateCommand.name])
        XCTAssertEqual(exitCode, 0)
    }

    func testGenerateFixtures() throws {
        try fixturesPath.delete()

        Snapshot.recording = true
        let tests = Tests()
        try tests.testGenerate()
    }
}
