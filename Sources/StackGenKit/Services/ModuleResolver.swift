import Foundation
import Path

/// The service that resolves the modules specified in the stackgen.yml file
public class ModuleResolver {
    private let stackgenFile: StackGenFile
    /// A cache used to speed up module resolution
    private var transitiveDependenciesCache: [String: [Dependency]] = [:]
    private let env: Env

    public init(_ stackgenFile: StackGenFile, _ env: Env) throws {
        self.stackgenFile = stackgenFile
        self.env = env
    }

    /// The entry point used to resolve the modules
    public func resolve() throws -> (firstPartyModules: [FirstPartyModule.Output], thirdPartyModules: [ThirdPartyModule.Output]) {
        // Perform prechecks on the modules
        try ensureUniqueModuleNames(stackgenFile)

        // Prepare
        let inputModules = populateDependencyKeys(stackgenFile.firstPartyModules)

        // Get modules
        let thirdPartyModules = stackgenFile.thirdPartyModules.map { resolve($0) }
        let firstPartyModules = try inputModules.map { try resolve($0, inputModules, thirdPartyModules) }
        return (firstPartyModules, thirdPartyModules)
    }

    private func ensureUniqueModuleNames(_ stackgenFile: StackGenFile) throws {
        let allModules: [Module] = stackgenFile.firstPartyModules + stackgenFile.thirdPartyModules
        let duplicates = Dictionary(grouping: allModules) { $0.name }
            .filter { $1.count > 1 }
            .map { $0.key }
        if duplicates.isEmpty == false {
            throw CustomError(.foundDuplicatedModules(duplicates))
        }

        for module in stackgenFile.firstPartyModules {
            for (_, dependencies) in module.dependencies {
                let duplicates = Dictionary(grouping: dependencies) { $0 }
                    .filter { $1.count > 1 }
                    .map { $0.key }
                if duplicates.isEmpty == false {
                    throw CustomError(.foundDuplicatedDependencies(duplicates, module.name))
                }
            }
        }

    }

    private func resolve(_ module: ThirdPartyModule.Input) -> ThirdPartyModule.Output {
        return ThirdPartyModule.Output(.init(name: module.name), module.dictionary)
    }

    /// Prefill dependency keys that do not have any dependency with empty arrays, so accessing them in the template is cleaner and safer
    /// Instead of having to do: `{% for dependency in module.transitiveDependencies.main|default:"" %}`
    /// We allow to just do: `{% for dependency in module.transitiveDependencies.main %}`
    private func populateDependencyKeys(_ modules: [FirstPartyModule.Input]) -> [FirstPartyModule.Input] {
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

    private func getTransitiveDependencies(_ dependency: String, _ middleware: [FirstPartyModule.Input], _ thirdParty: [ThirdPartyModule.Output]) throws -> [Dependency] {
        if let transitiveDependencies = transitiveDependenciesCache[dependency] {
            return transitiveDependencies
        }

        var transitiveDependencies: Set<Dependency> = []

        if let module = middleware.first(where: { $0.name == dependency }) {
            transitiveDependencies.insert(.firstParty(module))

            try module.dependencies.main.forEach {
                try getTransitiveDependencies($0, middleware, thirdParty).forEach {
                    transitiveDependencies.insert($0)
                }
            }
        } else if let module = thirdParty.first(where: { $0.name == dependency }) {
            transitiveDependencies.insert(.thirdParty(module))
        } else {
            throw CustomError(.unknownModule(dependency, middleware, thirdParty))
        }

        return Array(transitiveDependencies)
    }

    private func getTransitiveDependencies(_ module: FirstPartyModule.Input, _ middleware: [FirstPartyModule.Input], _ thirdParty: [ThirdPartyModule.Output]) throws -> [String: [String]] {
        var result: [String: [String]] = [:]

        for (flavour, dependencies) in module.dependencies {
            var transitiveDependencies: Set<Dependency> = []

            for dependency in dependencies {
                try getTransitiveDependencies(dependency, middleware, thirdParty).forEach {
                    transitiveDependencies.insert($0)
                }
            }

            result[flavour] = Array(transitiveDependencies).sorted().map { $0.name }
        }

        return result
    }

    private func resolve(_ module: FirstPartyModule.Input, _ middleware: [FirstPartyModule.Input], _ thirdParty: [ThirdPartyModule.Output]) throws -> FirstPartyModule.Output {
        let module = FirstPartyModule.Output(
            name: module.name,
            location: module.path.output,
            dependencies: module.dependencies,
            transitiveDependencies: try getTransitiveDependencies(module, middleware, thirdParty)
        )

        env.reporter.info(.books, "resolved module \(module.name)")

        return module
    }
}

// MARK: Dependency. Used to sort the transitive dependencies

private enum Dependency: Module {
    case firstParty(FirstPartyModule.Input)
    case thirdParty(ThirdPartyModule.Output)

    var name: String {
        switch self {
        case let .firstParty(module):
            return module.name

        case let .thirdParty(module):
            return module.name
        }
    }

    var kind: ModuleKind {
        switch self {
        case let .firstParty(module):
            return module.kind

        case let .thirdParty(module):
            return module.kind
        }
    }
}

extension Dependency: Hashable {
    public var hashValue: Int {
        name.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        name.hash(into: &hasher)
    }
}

private extension Array where Element == Dependency {
    func sorted() -> [Element] {
        return self
            .sorted { $0.name < $1.name }
            .sorted { $0.kind < $1.kind }
    }
}

// MARK: Module protocol. Used to ensure unique module names

private protocol Module {
    var name: String { get }
    var kind: ModuleKind { get }
}

extension FirstPartyModule.Input: Module {
    var kind: ModuleKind { .firstParty }
}

extension ThirdPartyModule.Input: Module {
    var name: String { element1.name }
    var kind: ModuleKind { .thirdParty }
}

// MARK: Dictionary extension. Used to obtain the transitive dependencies

private extension Dictionary where Key == String, Value == [String] {
    var main: [String] {
        return self["main"] ?? []
    }
}
