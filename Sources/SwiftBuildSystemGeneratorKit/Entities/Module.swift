import Path
import Yams
import Foundation
import Version

public struct Module: Encodable, Hashable, ContextConvertible {
    public let name: String
    public let path: Path
    public let version: Version
    public let mainTarget: Target
    public let testTarget: Target

    public init(
        _ middlewareModule: Module.Middleware,
        resolveDependenciesUsing middlewareModules: [Module.Middleware]
    ) throws {
        let path = middlewareModule.path
        let name = middlewareModule.name

        self.name = name
        self.path = path
        self.version = Current.globals.version

        let folderStructure: FolderStructureInterface
        switch Current.globals.folderStructure {
        case .gradle:
            folderStructure = GradleFolderStructure("swift")

        case .custom:
            folderStructure = CustomFolderStructure(name)
        }

        self.mainTarget = Target(
            name: name,
            sources: folderStructure.sources.map { path/$0 },
            dependencies: try Self.computeDependencies(name, middlewareModule.yamlModule.dependencies, middlewareModules)
        )

        self.testTarget = Target(
            name: folderStructure.testTargetName(for: name),
            sources: folderStructure.tests.map { path/$0 },
            dependencies: try Self.computeDependencies(name, middlewareModule.yamlModule.testDependencies, middlewareModules)
        )
    }

    private static func computeDependencies(
        _ name: String,
        _ dependencies: [String]?,
        _ middlewareModules: [Module.Middleware]
    ) throws -> [Dependency] {
        return try (dependencies ?? []).map { dependency in
            if let middlewareModule = middlewareModules.first(where: { $0.name == dependency }) {
                return Dependency(middlewareModule)
            } else if let framework = try Current.carthageService.getFrameworks().first(where: { $0.name == dependency })  {
                return Dependency(framework)
            } else {
                let modules = [
                    middlewareModules.map { $0.path.relative(to: cwd) },
                    try Current.carthageService.getFrameworks().map { $0.name }
                    ]
                    .flatMap { $0 }

                throw CustomError(.dependencyNotFoundAmongDetectedModules(moduleName: name, dependencyName: dependency, detectedModules: modules))
            }
        }
    }
}
