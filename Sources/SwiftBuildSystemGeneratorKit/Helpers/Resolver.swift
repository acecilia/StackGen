import Foundation

class Resolver {
    let moduleContexts: [Target.Output]

    init(_ workspace: WorkspaceFile) throws {
        let middlewareTargets = try workspace.modules.map { try Self.resolve($0) }
        let artifacts = try Self.resolve(artifacts: workspace.artifacts, versionSpecs: workspace.versionSpecs)
        let dependencies: [Dependency.Middleware] = middlewareTargets.map {.target($0) } + artifacts.map {.artifact($0) }
        self.moduleContexts = try Self.resolve(middlewareTargets, using: dependencies)
    }

    private static func resolve(artifacts: [Artifact.Input], versionSpecs: [VersionSpec]) throws -> [Artifact.Output] {
        let paths = try artifacts.flatMap { artifact in
            try artifact.paths.flatMap { artifactsPath in
                try artifactsPath.ls().map { $0.self }.filter {
                    try NSRegularExpression(pattern: "^\(artifact.regex)$").matches($0.relative(to: artifactsPath))
                }
            }
        }

        let versionResolver = VersionResolver(versionSpecs)

        return try paths
            .map { Artifact.Middleware(name: $0.basename(dropExtension: true), path: $0) }
            .map { Artifact.Output(name: $0.name, path: $0.path, version: try versionResolver.resolve(dependencyName: $0.name)) }
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

    private static func resolve(dependencyName: String, using dependencies: [Dependency.Middleware]) throws -> Dependency.Output {
        let dependencyCandidates = dependencies.filter { $0.name == dependencyName }

        switch dependencyCandidates.count {
        case 0:
            throw CustomError(.moduleNotFoundAmongDetectedModules(dependencyName, dependencies.map { $0.name }))

        case 1:
            let dependencyCandidate = dependencyCandidates[0]

            switch dependencyCandidate {
            case .target(let middlewareTarget):
                let target = try resolve(middlewareTarget, using: dependencies)
                return .target(target)

            case .artifact(let artifact):
                return .artifact(artifact)
            }

        default:
            throw CustomError(.multipleModulesWithSameNameFoundAmongDetectedModules(dependencyName, dependencies.map { $0.name }))
        }
    }

    private static func resolve(_ middlewareTarget: Target.Middleware, using dependencies: [Dependency.Middleware]) throws -> Target.Output {
        return Target.Output(
            name: middlewareTarget.name,
            path: middlewareTarget.path,
            subpaths: middlewareTarget.path.find().type(.directory).map { $0.self },
            dependencies: try middlewareTarget.dependencies.mapValues {
                try $0.map {
                    try resolve(dependencyName: $0, using: dependencies)
                }
            }
        )
    }

    private static func resolve(_ middlewareTargets: [Target.Middleware], using dependencies: [Dependency.Middleware]) throws -> [Target.Output] {
        try middlewareTargets.map {
            try resolve($0, using: dependencies)
        }
    }
}
