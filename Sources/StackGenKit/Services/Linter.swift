import Foundation
import Path

/// The service that lints the stackgen.yml file
public class Linter {
    private let env: Env
    private let lintOptions: LintOptions

    public init(_ env: Env, _ lintOptions: LintOptions) {
        self.env = env
        self.lintOptions = lintOptions
    }

    public func checkModulesSorting(_ stackgenFile: StackGenFile) throws {
        switch lintOptions.modulesSorting {
        case .alphabetically:
            func checkSorting(_ modules: [String]) throws {
                let sortedModules = modules.sortedAlphabetically()
                if modules != sortedModules {
                    throw StackGenError(.modulesSorting(modules, sortedModules))
                }
            }
            try checkSorting(stackgenFile.firstPartyModules.map { $0.name })
            try checkSorting(stackgenFile.thirdPartyModules.map { $0.name })

        case .none:
            break
        }
    }

    public func checkDependenciesSorting(_ stackgenFile: StackGenFile, _ modules: [Module.Input]) throws {
        switch lintOptions.dependenciesSorting {
        case .alphabeticallyAndByKind:
            for module in stackgenFile.firstPartyModules {
                for (dependencyGroup, dependencies) in module.dependencies {
                    let modules = try dependencies.map { try modules.get(named: $0) }
                    let sortedModules = modules.sortedByNameAndKind()
                    if modules != sortedModules {
                        throw StackGenError(
                            .dependenciesSorting(
                                module.name,
                                dependencyGroup,
                                modules.map { $0.name },
                                sortedModules.map { $0.name }
                            )
                        )
                    }
                }
            }

        case .none:
            break
        }
    }

    public func checkTransitiveDependenciesDuplication(
        _ module: FirstPartyModule.Input,
        _ dependency: Module.Input,
        _ transitiveDependencies: Set<Module.Input>
    ) throws {
        guard lintOptions.transitiveDependenciesDuplication else {
            return
        }

        if transitiveDependencies.contains(dependency) {
            throw StackGenError(.transitiveDependencyDuplication(module.name, dependency.name))
        }
    }
}
