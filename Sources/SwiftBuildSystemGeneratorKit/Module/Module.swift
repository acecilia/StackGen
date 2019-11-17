import Path
import Yams
import Foundation

public struct Module: Codable, ContextConvertible {
    public let globals: Globals?
    public let name: String
    public let path: Path
    public let mainTarget: Target
    public let testTarget: Target?

    public init(_ middlewareModule: Module.Middleware, resolveDependenciesUsing middlewareModules: [Module.Middleware]) throws {
        let folderStructure: FolderStructureInterface
        switch middlewareModule.yamlModule.folderStructure {
        case .gradle, nil:
            folderStructure = GradleFolderStructure("swift")
        }

        self.globals = middlewareModule.yamlModule.globals

        let path = middlewareModule.path
        self.name = path.basename()

        self.path = path
        self.mainTarget = Target(
            name: name,
            sources: folderStructure.sources.map { path/$0 },
            dependencies: try Self.computeDependencies(name, path, middlewareModule.yamlModule.dependencies, middlewareModules)
        )

        self.testTarget = Target(
            name: name + "Tests",
            sources: folderStructure.tests.map { path/$0 },
            dependencies: []
        )
    }

    private static func computeDependencies(
        _ name: String,
        _ path: Path,
        _ dependenciesPaths: [Path]?,
        _ middlewareModules: [Module.Middleware]
    ) throws -> [Module] {
        return try (dependenciesPaths ?? []).map { dependencyPath in
            guard let middlewareModule = middlewareModules.first(where: { $0.path == dependencyPath }) else {
                let dependency = dependencyPath.relative(to: path)
                let modules = middlewareModules.map { $0.path.relative(to: Path.cwd) }.joined(separator: "', '")
                throw UnexpectedError("Module '\(name)' specifies the dependency '\(dependency)', but such dependency could not be found among the considered modules: '\(modules)'")
            }
            return try Module(middlewareModule, resolveDependenciesUsing: middlewareModules)
        }
    }
}
