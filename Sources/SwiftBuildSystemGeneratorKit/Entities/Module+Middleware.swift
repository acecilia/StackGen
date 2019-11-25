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
            if content.isEmpty {
                self.yamlModule = Module.Yaml()
            } else {
                self.yamlModule = try YAMLDecoder().decode(Module.Yaml.self, from: content, userInfo: [.relativePath: path])
            }
        }
    }
}

