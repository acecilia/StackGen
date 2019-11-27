import Path
import Yams
import Foundation

extension Module {
    public struct Middleware: Decodable {
        public let path: Path
        public let yamlModule: Module.Yaml

        public init(_ moduleFilePath: Path) throws {
            self.path = moduleFilePath.parent

            let content = try String(contentsOf: moduleFilePath)
            // The YAMLDecoder fails if the file to decode is empty
            if content.isEmpty {
                self.yamlModule = Module.Yaml()
            } else {
                self.yamlModule = try YAMLDecoder().decode(from: content, userInfo: [.relativePath: path])
            }
        }
    }
}

