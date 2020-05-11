import Foundation
import Path

class ModuleResolver {
    private let bsgFile: BsgFile
    private let subpaths: [Path]
    private var modulesCache: [String: FirstPartyModule.Output] = [:]

    init(_ bsgFile: BsgFile) throws {
        self.bsgFile = bsgFile
        self.subpaths = try cwd.fastFindDirectories()
    }

    func resolve() throws -> (firstPartyModules: [FirstPartyModule.Output], thirdPartyModules: [ThirdPartyModule.Output]) {
        let thirdPartyModules = resolve(bsgFile.thirdPartyModules)
        let inputModules = populateDependencyKeys(bsgFile.firstPartyModules)
        let middlewareModules = try inputModules.map { try resolve($0) }
        let firstPartyModules = try resolve(middlewareModules, thirdPartyModules: thirdPartyModules)
        return (firstPartyModules, thirdPartyModules)
    }

    private func resolve(_ modules: [ThirdPartyModule.Input]) -> [ThirdPartyModule.Output] {
        return modules.map {
            ThirdPartyModule.Output(.init(name: $0.name), $0.dictionary)
        }
    }

    /// Prefill dependency keys that do not have any dependency with empty arrays, so accessing them in the template is cleaner and safer
    /// Instead of having to do: `{% for dependency in module.transitiveDependencies.main|default:"" %}`
    /// We allow to just do: `{% for dependency in module.transitiveDependencies.main %}`
    private func populateDependencyKeys(_ modules: [FirstPartyModule.Input]) -> [FirstPartyModule.Input] {
        let keys = modules
            .reduce(into: Set<String>()) { result, module in
                module.dependencies.keys.forEach { result.insert($0) }
            }
            .sorted()
        let dict: [String: [String]] = keys.reduce(into: [:]) { result, key in
            result[key] = []
        }
        return modules.map {
            let newDependenciesDict = $0.dependencies.merging(dict) { current, _ in current }
            return FirstPartyModule.Input(id: $0.id, dependencies: newDependenciesDict)
        }
    }

    private func resolve(_ module: FirstPartyModule.Input) throws -> FirstPartyModule.Middleware {
        guard let path = subpaths.first(where: { $0.string.hasSuffix(module.id) }) else {
            throw CustomError(.moduleNotFoundInFilesystem(module.id))
        }

        let target = FirstPartyModule.Middleware(
            name: path.basename(dropExtension: true),
            location: path,
            dependencies: module.dependencies
        )

        reporter.info(.books, "module \(target.name) found at path \(target.location.relative(to: cwd))")

        return target
    }

    private func resolve(dependencyName: String, using modules: [FirstPartyModule.Middleware], _ thirdPartyModules: [ThirdPartyModule.Output]) throws -> Dependency.Output {
        let moduleCandidates = modules.filter { $0.name == dependencyName }

        switch moduleCandidates.count {
        case 0:
            // TODO: finish this up
            return .thirdParty(thirdPartyModules.first { $0.name == dependencyName }!)

        case 1:
            let moduleCandidate = moduleCandidates[0]
            let target = try resolve(moduleCandidate, using: modules, thirdPartyModules: thirdPartyModules)
            return .firstParty(target.reduced)

        default:
            throw CustomError(.multipleModulesWithSameNameFoundAmongDetectedModules(dependencyName, modules.map { $0.name }))
        }
    }

    private func getTransitiveDependencies(from flavourDepDict: [String: [Dependency.Output]]) throws -> [String: [Dependency.Output]] {
        var transitiveFlavourDepDict: [String: [Dependency.Output]] = [:]

        for (flavour, dependencies) in flavourDepDict {
            var transitiveDependencies: Set<Dependency.Output> = []

            for dependency in dependencies {
                transitiveDependencies.insert(dependency)

                switch dependency {
                case let .firstParty(module):
                    let fullModule = try modulesCache[module.name].unwrap(
                        onFailure: "Module '\(module.name)' should have been processed already"
                    )
                    fullModule.transitiveDependencies[flavour]?.forEach {
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

    private func resolve(_ middlewareTarget: FirstPartyModule.Middleware, using modules: [FirstPartyModule.Middleware], thirdPartyModules: [ThirdPartyModule.Output]) throws -> FirstPartyModule.Output {
        if let module = modulesCache[middlewareTarget.name] {
            return module
        }

        let dependencies: [String: [Dependency.Output]] = try middlewareTarget.dependencies.mapValues {
            try $0
                .map { try resolve(dependencyName: $0, using: modules, thirdPartyModules) }
                .sorted()
        }
        let transitiveDependencies = try getTransitiveDependencies(from: dependencies)

        let module = FirstPartyModule.Output(
            name: middlewareTarget.name,
            location: middlewareTarget.location.output,
            dependencies: dependencies,
            transitiveDependencies: transitiveDependencies
        )
        modulesCache[module.name] = module
        return module
    }

    private func resolve(_ middlewareTargets: [FirstPartyModule.Middleware], thirdPartyModules: [ThirdPartyModule.Output]) throws -> [FirstPartyModule.Output] {
        try middlewareTargets.map {
            try resolve($0, using: middlewareTargets, thirdPartyModules: thirdPartyModules)
        }
    }
}

private extension Array where Element == Dependency.Output {
    func sorted() -> [Dependency.Output] {
        return self
            .sorted { $0.name < $1.name }
            .sorted { $0.kind < $1.kind }
    }
}
