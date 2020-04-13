import XCTest

extension XCTestCase {
    func assertGenerate(_ template: Template, testFilePath: String = #file, function: String = #function) throws {
        let r = try generate(using: template, testFilePath:testFilePath, function: function)
        // runCommand("open \(r.destination)")
        XCTAssertEqual(r.exitCode, 0, "Generation failed using templates '\(template.path)' at '\(r.destination)'")
    }

    func assertSPMBuild() throws {
        let r = runCommand("swift build")
        XCTAssertEqual(r.exitCode, 0, "SPM build failed: '\((r.output + r.error).joined(separator: "\n"))'")
    }

    func assertSetup() {
        let r = runCommand(". ./taskfile; setup")
        XCTAssertEqual(r.exitCode, 0, "Setup failed: '\((r.output + r.error).joined(separator: "\n"))'")
    }

    func assertTest() {
        let r = runCommand(". ./taskfile; test")
        XCTAssertEqual(r.exitCode, 0, "Test failed: '\((r.output + r.error).joined(separator: "\n"))'")
    }

    func assertArchive() {
        let r = runCommand(". ./taskfile; archive")
        XCTAssertEqual(r.exitCode, 0, "Archive failed: '\((r.output + r.error).joined(separator: "\n"))'")
    }

    func assertLefthook() {
        let r = runCommand("lefthook run pre-commit")
        XCTAssertEqual(r.exitCode, 0, "Lefthook failed: '\((r.output + r.error).joined(separator: "\n"))'")
    }
}
