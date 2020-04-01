import Foundation

class Resolver {
    let firstPartyModules: [FirstPartyModule.Output]
    let thirdPartyModules: [ThirdPartyModule.Output]

    init(_ bsgFile: BsgFile) throws {
        let middlewareModules = try bsgFile.modules.map { try Self.resolve($0) }
        let versionResolver = try VersionResolver(bsgFile.versionSources)
        self.firstPartyModules = try Self.resolve(middlewareModules, using: versionResolver)
        self.thirdPartyModules = Self.extractThirdPartyModules(firstPartyModules)
    }

    private static func extractThirdPartyModules(_ modules: [FirstPartyModule.Output]) -> [ThirdPartyModule.Output] {
        var thirdPartyModules: Set<ThirdPartyModule.Output> = []
        for module in modules {
            for (_, targetDependencies) in module.dependencies {
                for dependency in targetDependencies {
                    if case .thirdParty(let module) = dependency {
                        thirdPartyModules.insert(module)
                    }
                }
            }
        }
        return Array(thirdPartyModules).sorted { $0.name < $1.name }
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

    private static func getTransitiveDependencies(from flavourDepDict: [String: [Dependency.Output]]) -> [String: [Dependency.Output]] {
        var transitiveFlavourDepDict: [String: [Dependency.Output]] = [:]

        for (flavour, dependencies) in flavourDepDict {
            var transitiveDependencies: Set<Dependency.Output> = []

            for dependency in dependencies {
                transitiveDependencies.insert(dependency)

                switch dependency {
                case .firstParty(let module):
                    module.transitiveDependencies[flavour]?.forEach {
                        transitiveDependencies.insert($0)
                    }

                case .thirdParty:
                    break
                }
            }

            transitiveFlavourDepDict[flavour] = Array(transitiveDependencies).sorted()
        }

        return transitiveFlavourDepDict
    }

    private static func resolve(_ middlewareTarget: FirstPartyModule.Middleware, using modules: [FirstPartyModule.Middleware], _ versionResolver: VersionResolver) throws -> FirstPartyModule.Output {
        let dependencies: [String: [Dependency.Output]] = try middlewareTarget.dependencies.mapValues {
            try $0
                .map { try resolve(dependencyName: $0, using: modules, versionResolver) }
                .sorted()
        }
        let transitiveDependencies = getTransitiveDependencies(from: dependencies)

        return FirstPartyModule.Output(
            name: middlewareTarget.name,
            path: middlewareTarget.path,
            subpaths: middlewareTarget.path.find().type(.directory).map { $0.self },
            dependencies: dependencies,
            transitiveDependencies: transitiveDependencies
        )
    }

    private static func resolve(_ middlewareTargets: [FirstPartyModule.Middleware], using versionResolver: VersionResolver) throws -> [FirstPartyModule.Output] {
        try middlewareTargets.map {
            try resolve($0, using: middlewareTargets, versionResolver)
        }
    }
}

private extension Array where Element == Dependency.Output {
    func sorted() -> [Dependency.Output] {
        return self
            .sorted { $0.name < $1.name }
            .sorted {
                if case .thirdParty(let left) = $0, case .thirdParty(let right) = $1 {
                    return left.source < right.source
                } else {
                    return $0.type < $1.type
                }
        }
    }
}
