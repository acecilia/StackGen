import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit

final class SwiftBuildSystemGeneratorTests: XCTestCase {
    override func setUp() {
        super.setUp()

        let projectPath = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Examples")
            .path
        FileManager.default.changeCurrentDirectoryPath(projectPath)
    }

    func testClean() throws {
        let cleanCommand = CleanCommand(reporter: DefaultReporter())
        try cleanCommand.execute()
    }
}
