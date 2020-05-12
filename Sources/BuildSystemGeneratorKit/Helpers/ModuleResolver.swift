import Foundation
import Path

class ModuleResolver {
    private let bsgFile: BsgFile
    private let subpaths: [Path]
    private var transitiveDependenciesCache: [String: [Dependency]] = [:]

    init(_ bsgFile: BsgFile) throws {
        self.bsgFile = bsgFile
        self.subpaths = try cwd.fastFindDirectories()
    }

    func resolve() throws -> (firstPartyModules: [FirstPartyModule.Output], thirdPartyModules: [ThirdPartyModule.Output]) {
        // Prepare
        let inputModules = populateDependencyKeys(bsgFile.firstPartyModules)

        // Preprocess first party modules
        let middlewareModules = try inputModules.map { try resolve($0) }

        // Perform prechecks on the modules
        try ensureUniqueModuleNames(bsgFile, middlewareModules)

        // Get modules
        let thirdPartyModules = bsgFile.thirdPartyModules.map { resolve($0) }
        let firstPartyModules = try middlewareModules.map { try resolve($0, middlewareModules, thirdPartyModules) }
        return (firstPartyModules, thirdPartyModules)
    }

    private func ensureUniqueModuleNames(_ bsgFile: BsgFile, _ middleware: [FirstPartyModule.Middleware]) throws {
        let allModules: [Module] = bsgFile.thirdPartyModules + middleware
        let duplicates = Dictionary(grouping: allModules) { $0.name }
            .filter { $1.count > 1 }
            .map { $0.key }
        if duplicates.isEmpty == false {
            throw CustomError(.foundDuplicatedModules(duplicates))
        }

        for module in middleware {
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
            return FirstPartyModule.Input(id: $0.id, dependencies: newDependenciesDict)
        }
    }

    private func resolve(_ module: FirstPartyModule.Input) throws -> FirstPartyModule.Middleware {
        let matchingPaths = subpaths
            .filter { $0.string.hasSuffix("/\(module.id)") }
            .sorted { $0.components.count < $1.components.count }
        guard let path = matchingPaths.first else {
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

    private func getTransitiveDependencies(_ dependency: String, _ middleware: [FirstPartyModule.Middleware], _ thirdParty: [ThirdPartyModule.Output]) throws -> [Dependency] {
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

    private func getTransitiveDependencies(_ module: FirstPartyModule.Middleware, _ middleware: [FirstPartyModule.Middleware], _ thirdParty: [ThirdPartyModule.Output]) throws -> [String: [String]] {
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

    private func resolve(_ module: FirstPartyModule.Middleware, _ middleware: [FirstPartyModule.Middleware], _ thirdParty: [ThirdPartyModule.Output]) throws -> FirstPartyModule.Output {
        return FirstPartyModule.Output(
            name: module.name,
            location: module.location.output,
            dependencies: module.dependencies,
            transitiveDependencies: try getTransitiveDependencies(module, middleware, thirdParty)
        )
    }
}

// MARK: Dependency. Used to sort the transitive dependencies

private enum Dependency: Module, Hashable {
    case firstParty(FirstPartyModule.Middleware)
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

extension FirstPartyModule.Middleware: Module {
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
