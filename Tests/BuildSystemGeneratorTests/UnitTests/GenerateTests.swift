import Path
import RuntimeTestCase
import XCTest

final class GenerateTests: RuntimeTestCase {
    static func testSpecs() -> [RuntimeTestCaseSpec<GenerateTests>] {
        return templatesPath.ls().directories.map { templatePath in
            RuntimeTestCaseSpec(templatePath.basename()) { $0.templatePath = templatePath }
        }
    }

    private var templatePath: Path!

    func runtimeTest() throws {
        let result = try generate(using: templatePath)
        XCTAssertEqual(result.exitCode, 0)
        assert(fixture: fixturesPath/templatePath.basename(), equals: result.destination)
    }
}
