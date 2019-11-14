import Foundation
import Path

extension Module {
    public struct Yaml: Codable {
        let folderStructure: FolderStructure?
        let dependencies: [Path]?

        init() {
            self.folderStructure = nil
            self.dependencies = nil
        }
    }
}



