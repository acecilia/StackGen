import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

final class FixtureGenerator: XCTestCase {
    func testGenerateFixtures() throws {
        try fixturesPath.delete()

        Snapshot.recording = true
        let tests = Tests()
        try tests.testGenerate()
    }
}
