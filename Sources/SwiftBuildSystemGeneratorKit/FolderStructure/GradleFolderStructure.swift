import Foundation

/// https://docs.gradle.org/current/userguide/java_plugin.html#sec:java_project_layout
class GradleFolderStructure: FolderStructureInterface {
    let language: String

    init(_ language: String) {
        self.language = language
    }

    var sources: [String] {
        ["src/main/\(language)"]
    }

    var resources: [String] {
        ["src/main/resources"]
    }

    var tests: [String] {
        ["src/test/\(language)"]
    }

    var testResources: [String] {
        ["src/test/resources"]
    }
}
