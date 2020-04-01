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
    }

    private func assertGenerate(_ templatePath: Path, function: String = #function) throws {
        let r = try generate(using: templatePath, function: function)
        // runCommand("open \(r.destination)")
        XCTAssertEqual(r.exitCode, 0, "Generation failed using templates '\(templatePath)' at '\(r.destination)'")
    }

    private func assertSetup() {
        let r = runCommand("source taskfile; setup")
        XCTAssertEqual(r.exitCode, 0, "Setup failed: '\((r.output + r.error).joined(separator: "\n"))'")
    }

    private func assertTest() {
        let r = runCommand("source taskfile; test")
        XCTAssertEqual(r.exitCode, 0, "Test failed: '\((r.output + r.error).joined(separator: "\n"))'")
    }

    private func assertArchive() {
        let r = runCommand("source taskfile; archive")
        XCTAssertEqual(r.exitCode, 0, "Archive failed: '\((r.output + r.error).joined(separator: "\n"))'")
    }
}
