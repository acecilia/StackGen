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
        self.name = middlewareModule.name
        self.path = path
        self.version = middlewareModule.yamlModule.version ?? Current.globals.version

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
            dependencies: try Self.computeDependencies(name, path, middlewareModule.yamlModule.dependencies, middlewareModules)
        )

        self.testTarget = Target(
            name: name + "Tests",
            sources: folderStructure.tests.map { path/$0 },
            dependencies: try Self.computeDependencies(name, path, middlewareModule.yamlModule.testDependencies, middlewareModules)
        )
    }

    private static func computeDependencies(
        _ name: String,
        _ modulePath: Path,
        _ dependencies: [String]?,
        _ middlewareModules: [Module.Middleware]
    ) throws -> [Dependency] {
        return try (dependencies ?? []).map { dependency in
            if let middlewareModule = middlewareModules.first(where: { $0.name == dependency }) {
                let module = try Module(middlewareModule, resolveDependenciesUsing: middlewareModules)
                return .module(module)
            } else if let framework = try CarthageService.shared.getFrameworks().first(where: { $0.name == dependency })  {
                let framework = Framework(
                    name: dependency,
                    version: framework.version
                )
                return .framework(framework)
            } else {
                let modules = [
                    middlewareModules.map { $0.path.relative(to: Current.wd) },
                    try CarthageService.shared.getFrameworks().map { $0.name }
                    ]
                    .flatMap { $0 }
                    .joined(separator: ", ")

                throw UnexpectedError("Module '\(name)' specifies the dependency '\(dependency)', but such dependency could not be found among the considered modules: '\(modules)'")
            }
        }
    }
}
