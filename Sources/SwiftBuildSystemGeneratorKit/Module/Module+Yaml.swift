import Foundation
import Path

extension Module {
    public struct Yaml: Codable {
        public let folderStructure: FolderStructure?
        public let dependencies: [Path]?

        public init() {
            self.folderStructure = nil
            self.dependencies = nil
        }
    }
}



