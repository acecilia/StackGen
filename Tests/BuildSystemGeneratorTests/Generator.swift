import XCTest
import BuildSystemGeneratorCLI
import BuildSystemGeneratorKit
import Path

final class _01_Generator: XCTestCase {
    func test_01_Clean() throws {
        try fixturesPath.delete()
        try testsOutputPath.delete()
    }

    func test_02_SelfGenerate() throws {
        let path = rootPath
        FileManager.default.changeCurrentDirectoryPath(path.string)

        let cli = BuildSystemGeneratorCLI()
        let exitCode = cli.execute(with: [GenerateCommand.name])
        XCTAssertEqual(exitCode, 0)
    }

    func test_03_GenerateFixtures() throws {
        try fixturesPath.delete()

        Snapshot.recording = true
        let tests = _02_UnitTests()
        try tests.testGenerate()
        Snapshot.recording = false
    }
}
