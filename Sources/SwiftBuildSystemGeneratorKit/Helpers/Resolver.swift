import Foundation

class Resolver {
    let moduleContexts: [Target.Output]

    init(_ workspace: WorkspaceFile) throws {
        let middlewareTargets = try workspace.modules.map { try Self.resolve($0) }
        let versionResolver = try VersionResolver(workspace.dependencies)
        self.moduleContexts = try Self.resolve(middlewareTargets, using: versionResolver)
    }

    private static func resolve(_ module: Module.Input) throws -> Target.Middleware {
        let directories = cwd.find().type(.directory).map { $0 }
        let pathCandidates = directories.filter { $0.basename(dropExtension: true) == module.name }
        switch pathCandidates.count {
        case 0:
            throw CustomError(.moduleNotFoundInFilesystem(module.name))

        case 1:
            let target = Target.Middleware(
                name: module.name,
                path: pathCandidates[0],
                dependencies: module.dependencies
            )
            return target

        default:
            throw CustomError(.multipleModulesWithTheSameNameFoundInFilesystem(module.name, pathCandidates))
        }
    }

    private static func resolve(dependencyName: String, using modules: [Target.Middleware], _ versionResolver: VersionResolver) throws -> Dependency.Output {
        let moduleCandidates = modules.filter { $0.name == dependencyName }

        switch moduleCandidates.count {
        case 0:
            return .artifact(try versionResolver.resolve(dependencyName: dependencyName))

        case 1:
            let moduleCandidate = moduleCandidates[0]
            let target = try resolve(moduleCandidate, using: modules, versionResolver)
            return .target(target)

        default:
            throw CustomError(.multipleModulesWithSameNameFoundAmongDetectedModules(dependencyName, modules.map { $0.name }))
        }
    }

    private static func resolve(_ middlewareTarget: Target.Middleware, using modules: [Target.Middleware], _ versionResolver: VersionResolver) throws -> Target.Output {
        return Target.Output(
            name: middlewareTarget.name,
            path: middlewareTarget.path,
            subpaths: middlewareTarget.path.find().type(.directory).map { $0.self },
            dependencies: try middlewareTarget.dependencies.mapValues {
                try $0.map {
                    try resolve(dependencyName: $0, using: modules, versionResolver)
                }
            }
        )
    }

    private static func resolve(_ middlewareTargets: [Target.Middleware], using versionResolver: VersionResolver) throws -> [Target.Output] {
        try middlewareTargets.map {
            try resolve($0, using: middlewareTargets, versionResolver)
        }
    }
}
