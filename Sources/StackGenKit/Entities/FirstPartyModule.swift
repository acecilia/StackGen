import Foundation
import Path

public enum FirstPartyModule {
    /// A representation of a first party module when specified in the stackGenfile
    public struct Input: AutoCodable, Hashable {
        public static let defaultDependencies: [String: [String]] = [:]

        public var name: String { path.basename() }
        public let path: Path

        /**
         A dictionary representing the dependencies of the module

         In general, the keys of the dictionary represent the kind of target. For example:

         ```
         {
            main: [ModuleA, ModuleB],
            UnitTests: [ModuleC],
            UITests: [ModuleD],
         }
         ```
         */
        public let dependencies: [String: [String]]

        public init(
            path: Path,
            dependencies: [String: [String]]
        ) {
            self.path = path
            self.dependencies = dependencies
        }
    }

    /// A representation of a first party module used for creating the template context
    public struct Output: Codable, Hashable {
        /// The name of the first party module
        public let name: String
        /// The location of the first party module
        public let location: Path.Output
        /// The dependencies of the first party module
        public let dependencies: [String: [String]]
        /// The transitive dependencies of the first party module
        public let transitiveDependencies: [String: [String]]
        /// The kind of dependency that this module represents
        public let kind: ModuleKind = .firstParty

        public init(
            name: String,
            location: Path.Output,
            dependencies: [String: [String]],
            transitiveDependencies: [String: [String]]
        ) {
            self.name = name
            self.location = location
            self.dependencies = dependencies
            self.transitiveDependencies = transitiveDependencies
        }
    }
}


