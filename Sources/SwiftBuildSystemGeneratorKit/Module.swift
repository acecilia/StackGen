import Path
import Yams

public struct Module: Codable {
    let name: String
    let path: Path
    let sources: [File]
    let tests: [File]
    let dependencies: [Path]

    public init(moduleFilePath: Path) throws {
        let content = try String(contentsOf: moduleFilePath)

        let yamlModule: YamlModule
        if content.isEmpty {
            yamlModule = YamlModule()
        } else {
            yamlModule = try YAMLDecoder().decode(YamlModule.self, from: content, userInfo: [.relativePath: moduleFilePath])
        }

        let modulePath = moduleFilePath.parent

        self.name = modulePath.basename()
        self.path = modulePath
        self.sources = [.glob("Sources/**/*")]
        self.tests = [.glob("Tests/**/*")]
        self.dependencies = yamlModule.dependencies ?? []
    }
}
