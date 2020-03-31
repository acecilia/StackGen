import Path
import RuntimeTestCase
import XCTest
import BuildSystemGeneratorKit

final class GenerateTests: RuntimeTestCase {
    static func testSpecs() -> [RuntimeTestCaseSpec<GenerateTests>] {
        return templatesPath.ls().directories.sorted().map { templatePath in
            RuntimeTestCaseSpec(templatePath.basename()) { $0.templatePath = templatePath }
        }
    }

    private var templatePath: Path!

    func runtimeTest() throws {
        // Generate
        let (testPath, generateExitCode) = try generate(using: templatePath)
        XCTAssertEqual(generateExitCode, 0)
        assert(fixure: fixturesPath/templatePath.basename(), equals: testPath)

        // Clean
        let cleanExitCode = clean()
        XCTAssertEqual(cleanExitCode, 0)
        assert(reference: examplesPath, equals: testPath, exclude: [BsgFile.fileName])
    }
}
