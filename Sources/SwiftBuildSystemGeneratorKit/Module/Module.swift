import Path
import Yams
import Foundation

public struct Module: Codable, DictionaryConvertible {
    public let name: String
    public let path: Path
    public let sources: [Path]
    public let testName: String
    public let tests: [Path]
    public let dependencies: [Module]

    public init(_ rawModule: RawModule, resolveDependenciesUsing rawModules: [RawModule]) throws {
        let folderStructure: FolderStructureInterface
        switch rawModule.yamlModule.folderStructure {
        case .gradle, nil:
            folderStructure = GradleFolderStructure("swift")
        }

        let path = rawModule.path

        self.name = path.basename()
        self.path = path
        self.sources = folderStructure.sources.map { path/$0 }
        self.testName = name + "Tests"
        self.tests = folderStructure.tests.map { path/$0 }
        self.dependencies = try Self.computeDependencies(name, path, rawModule.yamlModule.dependencies, rawModules)
    }

    private static func computeDependencies(
        _ name: String,
        _ path: Path,
        _ dependenciesPaths: [Path]?,
        _ rawModules: [RawModule]
    ) throws -> [Module] {
        return try (dependenciesPaths ?? []).map { dependencyPath in
            guard let rawModule = rawModules.first(where: { $0.path == dependencyPath }) else {
                let dependency = dependencyPath.relative(to: path)
                let modules = rawModules.map { $0.path.relative(to: Path.cwd) }.joined(separator: "', '")
                throw UnexpectedError("Module '\(name)' specifies the dependency '\(dependency)', but such dependency could not be found among the considered modules: '\(modules)'")
            }
            return try Module(rawModule, resolveDependenciesUsing: rawModules)
        }
    }
}

extension Module {
    func xcodeGenDictionary() throws -> [String: Any] {
        var dict = try asDictionary(basePath: path)
        dict[CodingKeys.dependencies.stringValue] = dependencies.map { $0.name + ".framework" }
        return dict
    }
}
