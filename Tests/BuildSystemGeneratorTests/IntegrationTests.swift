import XCTest
import BuildSystemGeneratorKit
import Path
import RuntimeTestCase

final class IntegrationTests: RuntimeTestCase {
    static func testSpecs() -> [RuntimeTestCaseSpec<IntegrationTests>] {
        return templatesPath.ls().directories.sorted().map { templatePath in
            RuntimeTestCaseSpec(templatePath.basename()) { $0.templatePath = templatePath }
        }
    }

    private var templatePath: Path!

    func runtimeTest() throws {
        try assertGenerate(templatePath)
        assertSetup()
        assertTest()
        assertArchive()
        assertLefthook()
    }

    private func assertGenerate(_ templatePath: Path, function: String = #function) throws {
        let r = try generate(using: templatePath, function: function)
        // runCommand("open \(r.destination)")
        XCTAssertEqual(r.exitCode, 0, "Generation failed using templates '\(templatePath)' at '\(r.destination)'")
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
