import XCTest
import BuildSystemGeneratorKit
import Path
import RuntimeTestCase

final class IntegrationTests: RuntimeTestCase {
    static func testSpecs() -> [RuntimeTestCaseSpec<IntegrationTests>] {
        return Template.Swift_BuildSystem.map { template in
            RuntimeTestCaseSpec(template.rawValue) { $0.template = template }
        }
    }

    private var template: Template!

    func runtimeTest() throws {
        try assertGenerate(template)
        assertSetup()
        assertTest()
        // Archiving requires a provisioning profile on CI, which is not setup yet
        // assertArchive()
        assertLefthook()
    }

    private func assertGenerate(_ template: Template, function: String = #function) throws {
        let r = try generate(using: template, function: function)
        // runCommand("open \(r.destination)")
        XCTAssertEqual(r.exitCode, 0, "Generation failed using templates '\(template.path)' at '\(r.destination)'")
    }

    private func assertSetup() {
        let r = runCommand(". ./taskfile; setup")
        XCTAssertEqual(r.exitCode, 0, "Setup failed: '\((r.output + r.error).joined(separator: "\n"))'")
    }

    private func assertTest() {
        let r = runCommand(". ./taskfile; test")
        XCTAssertEqual(r.exitCode, 0, "Test failed: '\((r.output + r.error).joined(separator: "\n"))'")
    }

    private func assertArchive() {
        let r = runCommand(". ./taskfile; archive")
        XCTAssertEqual(r.exitCode, 0, "Archive failed: '\((r.output + r.error).joined(separator: "\n"))'")
    }

    private func assertLefthook() {
        let r = runCommand("lefthook run pre-commit")
        XCTAssertEqual(r.exitCode, 0, "Lefthook failed: '\((r.output + r.error).joined(separator: "\n"))'")
    }
}
