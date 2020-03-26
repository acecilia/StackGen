import XCTest
import BuildSystemGeneratorKit
import Path

final class _03_IntegrationTests: XCTestCase {
    func testAll() throws {
        for templatesPath in templatesPath.ls().directories {
            try assertGenerate(templatesPath)
            assertSetup()
            assertTest()
        }
    }

    private func assertGenerate(_ templatesPath: Path, function: String = #function) throws {
        let r = try generate(using: templatesPath, function: function)
        XCTAssertEqual(r.exitCode, 0, "Generation failed using templates '\(templatesPath)' at '\(r.destination)'")
    }

    private func assertSetup() {
        let r = runCommand("source taskfile; setup")
        XCTAssertEqual(r.exitCode, 0, "Setup failed: '\((r.output + r.error).joined(separator: "\n"))'")
    }

    private func assertTest() {
        let r = runCommand("source taskfile; test")
        XCTAssertEqual(r.exitCode, 0, "Test failed: '\((r.output + r.error).joined(separator: "\n"))'")
    }
}
