import Path
import RuntimeTestCase
import XCTest
import StackGenKit

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
        let (testPath, generateExitCode) = try prefillAndGenerate(using: template)
        XCTAssertEqual(generateExitCode, 0)
        assert(fixture: fixturesPath/template.rawValue, equals: testPath)

        // Clean
        let cleanExitCode = clean(using: template)
        XCTAssertEqual(cleanExitCode, 0)
        if let prefillPath = template.prefillPath {
            assert(reference: prefillPath, equals: testPath, exclude: [StackGenFile.fileName])
        } else {
            XCTAssertTrue(testPath.find().type(.file).map { $0 }.isEmpty)
        }
    }

    func testGenerateWithDifferentTopLevel() throws {
        let template = Template.StackGen_Swift_BuildSystem_Xcodegen
        
        let destinationA = try tmp("destinationA")
        let destinationB = try tmp("destinationB")
        try prefill(destinationA, using: template)
        try (destinationA/StackGenFile.fileName).move(into: destinationB)
        try patchTopLevel(at: destinationB/StackGenFile.fileName, using: destinationA)

        let exitCode = try generate(in: destinationB, using: template)
        XCTAssertEqual(exitCode, 0)
        assert(reference: fixturesPath/template.rawValue, equals: destinationA, exclude: [StackGenFile.fileName])
    }
}
