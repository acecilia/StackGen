import XCTest
import BuildSystemGeneratorCLI
import BuildSystemGeneratorKit
import Path

final class AAA_Generator: XCTestCase {
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
        for testSpec in GenerateTests.testSpecs() {
            let test = GenerateTests()
            testSpec.setup(test)
            try test.runtimeTest()
        }
        Snapshot.recording = false
    }
}
