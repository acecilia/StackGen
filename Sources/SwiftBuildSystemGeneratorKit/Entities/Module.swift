import Path
import Yams
import Foundation
import Version

public struct Module: Encodable, ContextConvertible {
    public let name: String
    public let version: Version
    public let path: Path
    public let mainTarget: Target
    public let testTarget: Target?

    public init(
        _ middlewareModule: Module.Middleware,
        resolveDependenciesUsing middlewareModules: [Module.Middleware]
    ) throws {
        let path = middlewareModule.path
        self.name = path.basename()
        self.version = middlewareModule.yamlModule.version ?? Current.globals.version
        self.path = path
        let folderStructure = Current.globals.folderStructure.build()
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
        _ modulePath: Path,
        _ dependencies: [Dependency.Yaml]?,
        _ middlewareModules: [Module.Middleware]
    ) throws -> [Dependency] {
        return try (dependencies ?? []).map { dependency in

            switch dependency {
            case let .module(path):
                guard let middlewareModule = middlewareModules.first(where: { $0.path == path }) else {
                    let dependency = path.relative(to: modulePath)
                    let modules = middlewareModules.map { $0.path.relative(to: Current.wd) }.joined(separator: "', '")
                    throw UnexpectedError("Module '\(name)' specifies the dependency '\(dependency)', but such dependency could not be found among the considered modules: '\(modules)'")
                }
                let module = try Module(middlewareModule, resolveDependenciesUsing: middlewareModules)
                return .module(module)

            case let .framework(name):
                let framework = Framework(
                    name: name,
                    version: Version(0, 0, 1) // Unimplemented
                )
                return .framework(framework)
            }

        }
    }
}
