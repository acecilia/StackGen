import Path
import Yams
import Foundation

public struct Module: Codable {
    public let name: String
    public let path: Path
    public let sources: [Path]
    public let tests: [Path]
    public let dependencies: [Path]

    public init(moduleFilePath: Path) throws {
        let content = try String(contentsOf: moduleFilePath)

        let yamlModule: YamlModule
        if content.isEmpty {
            yamlModule = YamlModule()
        } else {
            yamlModule = try YAMLDecoder().decode(YamlModule.self, from: content, userInfo: [.relativePath: moduleFilePath])
        }

        let modulePath = moduleFilePath.parent
        let moduleName = modulePath.basename()

        let folderStructure: FolderStructureInterface
        switch yamlModule.folderStructure {
        case .gradle, nil:
            folderStructure = GradleFolderStructure("swift")
        }

        self.name = moduleName
        self.path = modulePath
        self.sources = folderStructure.sources.map { modulePath/$0 }
        self.tests = folderStructure.tests.map { modulePath/$0 }
        self.dependencies = yamlModule.dependencies ?? []
    }
}

/// https://stackoverflow.com/questions/45209743/how-can-i-use-swift-s-codable-to-encode-into-a-dictionary
extension Module {
    func asDictionary(basePath: Path?) throws -> [String: Any] {
        let encoder = JSONEncoder()
        if let basePath = basePath {
            encoder.userInfo[.relativePath] = basePath
        }
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
  }
}
