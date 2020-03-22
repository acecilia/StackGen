import Foundation

class Resolver {
    let moduleContexts: [FirstPartyModule.Output]
    let artifacts: [ThirdPartyModule.Output]

    init(_ workspace: WorkspaceFile) throws {
        let middlewareTargets = try workspace.modules.map { try Self.resolve($0) }
        let versionResolver = try VersionResolver(workspace.versionSources)
        self.moduleContexts = try Self.resolve(middlewareTargets, using: versionResolver)
        self.artifacts = Self.extractArtifacts(moduleContexts)
    }

    private static func extractArtifacts(_ modules: [FirstPartyModule.Output]) -> [ThirdPartyModule.Output] {
        var artifacts: Set<ThirdPartyModule.Output> = []
        for module in modules {
            for (_, targetDependencies) in module.dependencies {
                for dependency in targetDependencies {
                    if case .thirdParty(let artifact) = dependency {
                        artifacts.insert(artifact)
                    }
                }
            }
        }
        return Array(artifacts).sorted { $0.name < $1.name }
    }
    private static func resolve(_ module: FirstPartyModule.Input) throws -> FirstPartyModule.Middleware {
        let directories = cwd.find().type(.directory).map { $0 }
        let pathCandidates = directories.filter { $0.string.hasSuffix(module.name) }
        switch pathCandidates.count {
        case 0:
            throw CustomError(.moduleNotFoundInFilesystem(module.name))

        case 1:
            let path = pathCandidates[0]
            let target = FirstPartyModule.Middleware(
                name: path.basename(dropExtension: true),
                path: path,
                dependencies: module.dependencies
            )
            return target

        default:
            throw CustomError(.multipleModulesWithTheSameNameFoundInFilesystem(module.name, pathCandidates))
        }
    }

    private static func resolve(dependencyName: String, using modules: [FirstPartyModule.Middleware], _ versionResolver: VersionResolver) throws -> Dependency.Output {
        let moduleCandidates = modules.filter { $0.name == dependencyName }

        switch moduleCandidates.count {
        case 0:
            return .thirdParty(try versionResolver.resolve(dependencyName: dependencyName))

        case 1:
            let moduleCandidate = moduleCandidates[0]
            let target = try resolve(moduleCandidate, using: modules, versionResolver)
            return .firstParty(target)

        default:
            throw CustomError(.multipleModulesWithSameNameFoundAmongDetectedModules(dependencyName, modules.map { $0.name }))
        }
    }

    private static func resolve(_ middlewareTarget: FirstPartyModule.Middleware, using modules: [FirstPartyModule.Middleware], _ versionResolver: VersionResolver) throws -> FirstPartyModule.Output {
        return FirstPartyModule.Output(
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

    private static func resolve(_ middlewareTargets: [FirstPartyModule.Middleware], using versionResolver: VersionResolver) throws -> [FirstPartyModule.Output] {
        try middlewareTargets.map {
            try resolve($0, using: middlewareTargets, versionResolver)
        }
    }
}
