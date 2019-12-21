import Foundation

public class CustomFolderStructure: FolderStructureInterface {
    public let targetName: String

    public init(_ targetName: String) {
        self.targetName = targetName
    }

    func testTargetName(for targetName: String) -> String {
        return "\(targetName)UnitTests"
    }

    public var sources: [String] {
        ["\(targetName)"]
    }

    public var tests: [String] {
        [testTargetName(for: targetName)]
    }
}
