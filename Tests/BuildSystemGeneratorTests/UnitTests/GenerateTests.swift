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
        assert(fixture: fixturesPath/template.rawValue, equals: testPath)

        // Clean
        let cleanExitCode = clean(using: template)
        XCTAssertEqual(cleanExitCode, 0)
        if let prefillPath = template.prefillPath {
            assert(reference: prefillPath, equals: testPath, exclude: [BsgFile.fileName])
        } else {
            XCTAssertTrue(testPath.find().type(.file).map { $0 }.isEmpty)
        }
    }

    func testGenerateWithDifferentTopLevel() throws {
        let template = Template.Swift_BuildSystem_Xcodegen
        
        let destinationA = try tmp("path_A")
        let destinationB = try tmp("path_B")

        try prefill(destinationA, using: template)
        try prefill(destinationB, using: template)

        try patchTopLevel(at: destinationB/BsgFile.fileName, using: destinationA)
        let cleanExitCode = try generate(in: destinationB, using: template)
        XCTAssertEqual(cleanExitCode, 0)

        assert(fixture: fixturesPath/template.rawValue, equals: destinationA)
    }
}
