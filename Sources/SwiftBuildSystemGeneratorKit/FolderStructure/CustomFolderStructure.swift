import Foundation

/// https://docs.gradle.org/current/userguide/java_plugin.html#sec:java_project_layout
class CustomFolderStructure: FolderStructureInterface {
    let targetName: String

    init(_ targetName: String) {
        self.targetName = targetName
    }

    var sources: [String] {
        ["\(targetName)"]
    }

    var tests: [String] {
        ["\(targetName)UnitTests"]
    }
}
