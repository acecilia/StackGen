import Foundation

class SPMFolderStructure: FolderStructureInterface {
    let moduleName: String

    init(_ moduleName: String) {
        self.moduleName = moduleName
    }

    var sources: [File] {
        [.glob("Sources/\(moduleName)/\(File.allFilesGlobSuffix)")]
    }

    var resources: [File] {
        [] // Unknown yet. See: https://forums.swift.org/t/draft-proposal-package-resources/29941
    }

    var tests: [File] {
        [.glob("Tests/\(moduleName)Tests/\(File.allFilesGlobSuffix)")]
    }

    var testResources: [File] {
        [] // Unknown yet. See: https://forums.swift.org/t/draft-proposal-package-resources/29941
    }
}
