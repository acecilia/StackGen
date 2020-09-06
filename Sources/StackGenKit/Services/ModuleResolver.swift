import Foundation
import Path

/// The service that resolves the modules specified in the stackgen.yml file
public class ModuleResolver {
    private let stackgenFile: StackGenFile
    private let linter: Linter
    /// A cache used to speed up module resolution
    private var transitiveDependenciesCache: [String: Set<Module.Input>] = [:]
    private let env: Env

    public init(_ stackgenFile: StackGenFile, _ env: Env) throws {
        self.stackgenFile = stackgenFile
        self.linter = Linter(env, stackgenFile.lintOptions)
        self.env = env
    }

    /// The entry point used to resolve the modules
    public func resolve() throws -> [Module.Output] {
        let modules = try getModules()

        // Perform checks on the modules
        try checkUniqueModuleNames(modules)
        try checkDuplicatedDependencies()
        try linter.checkModulesSorting(stackgenFile)
        try linter.checkDependenciesSorting(stackgenFile, modules)

        let resolvedModules: [Module.Output] = try modules.map {
            switch $0 {
            case let .firstParty(module):
                return .firstParty(try resolve(module, modules))

            case let .thirdParty(module):
                return .thirdParty(resolve(module))
            }
        }
        return resolvedModules
    }

    private func resolve(_ module: ThirdPartyModule.Input) -> ThirdPartyModule.Output {
        return ThirdPartyModule.Output(.init(name: module.name), module.untyped)
    }

    private func getModules() throws -> [Module.Input] {
        /// Prefill dependency groups that do not have any dependency with empty arrays, so accessing them in the template is cleaner and safer
        /// Instead of having to do: `{% for dependency in module.transitiveDependencies.main|default:"" %}`
        /// We allow to just do: `{% for dependency in module.transitiveDependencies.main %}`
        func populateDependencyGroups(_ modules: [FirstPartyModule.Input]) -> [FirstPartyModule.Input] {
            var dict: [String: [String]] = [:]
            modules.forEach {
                $0.dependencies.keys.forEach {
                    dict[$0] = []
                }
            }
            return modules.map {
                let newDependenciesDict = $0.dependencies.merging(dict) { current, _ in current }
                return FirstPartyModule.Input(path: $0.path, dependencies: newDependenciesDict)
            }
        }

        let firstPartyModules = populateDependencyGroups(stackgenFile.firstPartyModules)
        let allModules: [Module.Input] =
            firstPartyModules.map { .firstParty($0) } +
            stackgenFile.thirdPartyModules.map { .thirdParty($0) }
        return allModules
    }

    private func resolve(
        _ module: FirstPartyModule.Input,
        _ modules: [Module.Input]
    ) throws -> FirstPartyModule.Output {
        let module = FirstPartyModule.Output(
            name: module.name,
            path: env.root.join(module.path),
            dependencies: module.dependencies,
            transitiveDependencies: try getTransitiveDependencies(module, modules)
        )

        env.reporter.info(.books, "resolved module \(module.name)")

        return module
    }

    private func checkUniqueModuleNames(_ modules: [Module.Input]) throws {
        let duplicates = Dictionary(grouping: modules) { $0.name }
            .filter { $1.count > 1 }
            .map { $0.key }
            .sortedAlphabetically()
        if duplicates.isEmpty == false {
            throw StackGenError(.foundDuplicatedModules(duplicates))
        }
    }

    private func checkDuplicatedDependencies() throws {
        for module in stackgenFile.firstPartyModules {
            for (_, dependencies) in module.dependencies {
                let duplicates = Dictionary(grouping: dependencies) { $0 }
                    .filter { $1.count > 1 }
                    .map { $0.key }
                    .sortedAlphabetically()
                if duplicates.isEmpty == false {
                    throw StackGenError(.foundDuplicatedDependencies(duplicates, module.name))
                }
            }
        }
    }

    private func getTransitiveDependencies(
        _ name: String,
        _ modules: [Module.Input],
        _ dependenciesTree: [String]
    ) throws -> Set<Module.Input> {
        if dependenciesTree.contains(name) {
            throw StackGenError(.foundDependencyCycle(dependenciesTree + [name]))
        }

        if let transitiveDependencies = transitiveDependenciesCache[name] {
            return transitiveDependencies
        }

        let module = try modules.get(named: name)
        let dependenciesTree = dependenciesTree + [name]

        var transitiveDependencies: Set<Module.Input> = []
        switch module {
        case let .firstParty(module):
            try module.dependencies.main.forEach {
                let dependency = try modules.get(named: $0)
                transitiveDependencies.insert(dependency)

                try getTransitiveDependencies($0, modules, dependenciesTree).forEach {
                    transitiveDependencies.insert($0)
                }
            }

        case .thirdParty:
            // Third party modules do not specify dependencies
            break
        }

        transitiveDependenciesCache[name] = transitiveDependencies
        return transitiveDependencies
    }

    private func getTransitiveDependencies(
        _ module: FirstPartyModule.Input,
        _ modules: [Module.Input]
    ) throws -> [String: [String]] {
        var result: [String: [String]] = [:]

        for (dependencyGroup, dependencies) in module.dependencies {
            var transitiveDependencies: Set<Module.Input> = []
            // Allow the dependencyGroups that are not main to depend on main
            let dependenciesTree = dependencyGroup == "main" ? [module.name] : []

            for dependency in dependencies {
                try getTransitiveDependencies(dependency, modules, dependenciesTree).forEach {
                    transitiveDependencies.insert($0)
                }
            }

            for dependency in dependencies {
                let dependency = try modules.get(named: dependency)
                try linter.checkTransitiveDependenciesDuplication(module, dependency, transitiveDependencies)
                transitiveDependencies.insert(dependency)
            }

            result[dependencyGroup] = Array(transitiveDependencies)
                .sortedByNameAndKind()
                .map { $0.name }
        }

        return result
    }
}
