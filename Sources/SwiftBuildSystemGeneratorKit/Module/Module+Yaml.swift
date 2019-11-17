import Foundation
import Path

extension Module {
    public struct Yaml: Codable {
        public let globals: Globals?
        public let folderStructure: FolderStructure?
        public let dependencies: [Path]?

        public init() {
            self.globals = nil
            self.folderStructure = nil
            self.dependencies = nil
        }
    }
}



