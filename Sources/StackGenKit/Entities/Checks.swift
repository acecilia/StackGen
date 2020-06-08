import Foundation

public struct Checks: AutoCodable {
    public static let defaultModulesSorting: ModuleSorting = .alphabetically
    public static let defaultDependenciesSorting: DependencySorting = .alphabeticallyAndByKind
    public static let defaultTransitiveDependenciesDuplication: Bool = true

    /// The sorting of first and third party modules inside the stackgen.yml file
    public let modulesSorting: ModuleSorting
    /// The sorting of the module dependencies inside the stackgen.yml file
    public let dependenciesSorting: DependencySorting
    /// To check for duplication of transitive dependencies
    public let transitiveDependenciesDuplication: Bool

    public init(
        modulesSorting: ModuleSorting = defaultModulesSorting,
        dependenciesSorting: DependencySorting = defaultDependenciesSorting,
        transitiveDependenciesDuplication: Bool = defaultTransitiveDependenciesDuplication
    ) {
        self.modulesSorting = modulesSorting
        self.dependenciesSorting = dependenciesSorting
        self.transitiveDependenciesDuplication = transitiveDependenciesDuplication
    }
}

public enum ModuleSorting: String, Codable {
    case none
    case alphabetically
}

public enum DependencySorting: String, Codable {
    case none
    case alphabeticallyAndByKind
}
