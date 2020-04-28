import Foundation
import Path

class ModuleResolver {
    private let bsgFile: BsgFile
    private let subpaths: [Path]
    private let versionResolver: VersionResolver
    private var modulesCache: [String: FirstPartyModule.Output] = [:]

    init(_ bsgFile: BsgFile) throws {
        self.bsgFile = bsgFile
        self.subpaths = try cwd.fastFindDirectories()
        self.versionResolver = try VersionResolver(bsgFile.versionSources)
    }

    func resolve() throws -> (firstPartyModules: [FirstPartyModule.Output], thirdPartyModules: [ThirdPartyModule.Output]) {
        let middlewareModules = try bsgFile.modules.map { try resolve($0) }
        let firstPartyModules = try resolve(middlewareModules)
        let thirdPartyModules = extractThirdPartyModules(firstPartyModules)
        return (firstPartyModules, thirdPartyModules)
    }

    private func extractThirdPartyModules(_ modules: [FirstPartyModule.Output]) -> [ThirdPartyModule.Output] {
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

    private func resolve(_ module: FirstPartyModule.Input) throws -> FirstPartyModule.Middleware {
        let pathCandidates = subpaths.filter { $0.string.hasSuffix(module.id) }
        switch pathCandidates.count {
        case 0:
            throw CustomError(.moduleNotFoundInFilesystem(module.id))

        case 1:
            let path = pathCandidates[0]
            let target = FirstPartyModule.Middleware(
                name: path.basename(dropExtension: true),
                path: path,
                dependencies: module.dependencies
            )
            return target

        default:
            throw CustomError(.multipleModulesWithTheSameIdFoundInFilesystem(module.id, pathCandidates))
        }
    }

    private func resolve(dependencyName: String, using modules: [FirstPartyModule.Middleware], _ versionResolver: VersionResolver) throws -> Dependency.Output {
        let moduleCandidates = modules.filter { $0.name == dependencyName }

        switch moduleCandidates.count {
        case 0:
            return .thirdParty(try versionResolver.resolve(dependencyName: dependencyName))

        case 1:
            let moduleCandidate = moduleCandidates[0]
            let target = try resolve(moduleCandidate, using: modules)
            return .firstParty(target)

        default:
            throw CustomError(.multipleModulesWithSameNameFoundAmongDetectedModules(dependencyName, modules.map { $0.name }))
        }
    }

    private func getTransitiveDependencies(from flavourDepDict: [String: [Dependency.Output]]) -> [String: [Dependency.Output]] {
        var transitiveFlavourDepDict: [String: [Dependency.Output]] = [:]

        for (flavour, dependencies) in flavourDepDict {
            var transitiveDependencies: Set<Dependency.Output> = []

            for dependency in dependencies {
                transitiveDependencies.insert(dependency)

                switch dependency {
                case let .firstParty(module):
                    module.transitiveDependencies[flavour]?.forEach {
                        transitiveDependencies.insert($0)
                    }

                case let .thirdParty(module):
                    transitiveDependencies.insert(.thirdParty(module))
                }
            }

            transitiveFlavourDepDict[flavour] = Array(transitiveDependencies).sorted()
        }

        return transitiveFlavourDepDict
    }

    private func resolve(_ middlewareTarget: FirstPartyModule.Middleware, using modules: [FirstPartyModule.Middleware]) throws -> FirstPartyModule.Output {
        if let module = modulesCache[middlewareTarget.name] {
            return module
        }

        let dependencies: [String: [Dependency.Output]] = try middlewareTarget.dependencies.mapValues {
            try $0
                .map { try resolve(dependencyName: $0, using: modules, versionResolver) }
                .sorted()
        }
        let transitiveDependencies = getTransitiveDependencies(from: dependencies)

        let module = FirstPartyModule.Output(
            name: middlewareTarget.name,
            path: middlewareTarget.path,
            dependencies: dependencies,
            transitiveDependencies: transitiveDependencies
        )
        modulesCache[module.name] = module
        return module
    }

    private func resolve(_ middlewareTargets: [FirstPartyModule.Middleware]) throws -> [FirstPartyModule.Output] {
        try middlewareTargets.map {
            try resolve($0, using: middlewareTargets)
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
                    return $0.kind < $1.kind
                }
        }
    }
}
