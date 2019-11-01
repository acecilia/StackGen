import Path
import Yams
import Foundation

public struct RawModule: Codable {
    public let path: Path
    public let yamlModule: YamlModule

    public init(_ moduleFilePath: Path) throws {
        self.path = moduleFilePath.parent

        let content = try String(contentsOf: moduleFilePath)
        if content.isEmpty {
            self.yamlModule = YamlModule()
        } else {
            self.yamlModule = try YAMLDecoder().decode(YamlModule.self, from: content, userInfo: [.relativePath: path])
        }
    }
}
