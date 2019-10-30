import Foundation

/// https://docs.gradle.org/current/userguide/java_plugin.html#sec:java_project_layout
class GradleFolderStructure: FolderStructureInterface {
    let language: String

    init(_ language: String) {
        self.language = language
    }

    var sources: [File] {
        [.glob("src/main/\(language)/\(File.allFilesGlobSuffix)")]
    }

    var resources: [File] {
        [.glob("src/main/resources/\(File.allFilesGlobSuffix)")]
    }

    var tests: [File] {
        [.glob("src/test/\(language)/\(File.allFilesGlobSuffix)")]
    }

    var testResources: [File] {
        [.glob("src/test/resources/\(File.allFilesGlobSuffix)")]
    }
}
