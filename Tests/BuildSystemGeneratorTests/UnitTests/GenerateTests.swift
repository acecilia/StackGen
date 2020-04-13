import Path
import RuntimeTestCase
import XCTest
import BuildSystemGeneratorKit

final class GenerateTests: RuntimeTestCase {
    static func testSpecs() -> [RuntimeTestCaseSpec<GenerateTests>] {
        return Template.allCases.map { template in
            RuntimeTestCaseSpec(template.rawValue) { testCase in
                try testCase.generateTest(template)
            }
        }
    }

    func generateTest(_ template: Template) throws {
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
