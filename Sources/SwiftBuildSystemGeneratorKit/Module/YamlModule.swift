import Foundation
import Path

public struct YamlModule: Codable {
    let folderStructure: FolderStructure?
    let dependencies: [Path]?

    init() {
        self.folderStructure = nil
        self.dependencies = nil
    }
}


