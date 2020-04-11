import Path
import RuntimeTestCase
import XCTest
import BuildSystemGeneratorKit

final class GenerateTests: RuntimeTestCase {
    static func testSpecs() -> [RuntimeTestCaseSpec<GenerateTests>] {
        return Template.allCases.map { template in
            RuntimeTestCaseSpec(template.rawValue) { $0.template = template }
        }
    }

    private var template: Template!

    func runtimeTest() throws {
        // Generate
        let (testPath, generateExitCode) = try generate(using: template)
        XCTAssertEqual(generateExitCode, 0)
        assert(fixure: fixturesPath/template.rawValue, equals: testPath)

        if let prefillPath = template.prefillPath {
            // Clean
            let cleanExitCode = clean()
            XCTAssertEqual(cleanExitCode, 0)
            assert(reference: prefillPath, equals: testPath, exclude: [BsgFile.fileName])
        }
    }
}
