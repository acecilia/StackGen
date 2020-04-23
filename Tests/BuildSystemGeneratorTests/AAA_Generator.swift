import XCTest
import BuildSystemGeneratorCLI
import BuildSystemGeneratorKit
import Path

// This tests are used to regenerate the fixtures and other files. They are enabled by default, but disabled on CI
#if DISABLE_GENERATOR
typealias GeneratorTestCase = NSObject
#else
typealias GeneratorTestCase = XCTestCase
#endif

final class AAA_Generator: GeneratorTestCase {
    func test_01_Clean() throws {
        _ = runCommand("rm -rf \(fixturesPath.string)")
        _ = runCommand("rm -rf \(testsOutputPath.string)")
    }

    func test_02_SelfGenerate() throws {
        let path = rootPath
        FileManager.default.changeCurrentDirectoryPath(path.string)

        let cli = CLI()
        let exitCode = cli.execute(with: [Generate.name])
        XCTAssertEqual(exitCode, 0)
    }

    func test_03_GenerateFixtures() throws {
        Snapshot.recording = true
        for testSpec in GenerateTests.testSpecs() {
            let test = GenerateTests()
            try testSpec.implementation(test)
        }
        Snapshot.recording = false
    }
}
