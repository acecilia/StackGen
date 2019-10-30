import Path
import Yams

public struct Module: Codable {
    public let name: String
    public let path: Path
    public let sources: [File]
    public let tests: [File]
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

        case .SPM:
            folderStructure = SPMFolderStructure(moduleName)
        }

        self.name = moduleName
        self.path = modulePath
        self.sources = folderStructure.sources
        self.tests = folderStructure.tests
        self.dependencies = yamlModule.dependencies ?? []
    }
}
