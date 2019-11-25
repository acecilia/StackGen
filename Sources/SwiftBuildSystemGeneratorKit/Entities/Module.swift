import Path
import Yams
import Foundation

public struct Module: Encodable, ContextConvertible {
    public let name: String
    public let version: String
    public let path: Path
    public let mainTarget: Target
    public let testTarget: Target?

    public init(
        _ middlewareModule: Module.Middleware,
        _ globals: Globals,
        resolveDependenciesUsing middlewareModules: [Module.Middleware]
    ) throws {
        let path = middlewareModule.path
        self.name = path.basename()
        self.version = middlewareModule.yamlModule.version ?? globals.version
        self.path = path
        let folderStructure = globals.folderStructure.build()
        self.mainTarget = Target(
            name: name,
            sources: folderStructure.sources.map { path/$0 },
            dependencies: try Self.computeDependencies(name, path, globals, middlewareModule.yamlModule.dependencies, middlewareModules)
        )

        self.testTarget = Target(
            name: name + "Tests",
            sources: folderStructure.tests.map { path/$0 },
            dependencies: []
        )
    }

    private static func computeDependencies(
        _ name: String,
        _ modulePath: Path,
        _ globals: Globals,
        _ dependencies: [Dependency.Yaml]?,
        _ middlewareModules: [Module.Middleware]
    ) throws -> [Dependency] {
        return try (dependencies ?? []).map { dependency in

            switch dependency {
            case let .module(path):
                guard let middlewareModule = middlewareModules.first(where: { $0.path == path }) else {
                    let dependency = path.relative(to: modulePath)
                    let modules = middlewareModules.map { $0.path.relative(to: Options.rootPath) }.joined(separator: "', '")
                    throw UnexpectedError("Module '\(name)' specifies the dependency '\(dependency)', but such dependency could not be found among the considered modules: '\(modules)'")
                }
                let module = try Module(middlewareModule, globals, resolveDependenciesUsing: middlewareModules)
                return .module(module)

            case let .framework(name):
                fatalError("Third party '\(name)' is not supported yet")
            }

        }
    }
}
