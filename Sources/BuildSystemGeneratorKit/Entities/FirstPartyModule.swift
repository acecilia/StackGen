import Foundation
import Path

public enum FirstPartyModule {
    /// A representation of a first party module when specified in the bsgfile
    public struct Input: AutoCodable {
        public static let defaultDependencies: [String: [String]] = [:]

        /**
         An identifier that uniquely identifies the path of a first party module on the current directory.
         The last component of the path will be used as the name of the module

         - Most of the times, this would be the same as your module name. For example: `SwiftModule`
         - In case you use the same folder name in multiple places, you will need to add
         path components until only one matches. For example: `Libraries/SwiftModule`
         */
        public let id: String

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
            id: String,
            dependencies: [String: [String]]
        ) {
            self.id = id
            self.dependencies = dependencies
        }
    }

    /// A middleware representation of a first party module
    public struct Middleware {
        /// The name of the first party module
        public let name: String
        /// The location of the first party module
        public let location: Path
        /// The dependencies of the first party module
        public let dependencies: [String: [String]]

        public init(
            name: String,
            location: Path,
            dependencies: [String: [String]]
        ) {
            self.name = name
            self.location = location
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
        public let dependencies: [String: [Dependency.Output]]
        /// The transitive dependencies of the first party module
        public let transitiveDependencies: [String: [Dependency.Output]]
        /// The kind of dependency that this module represents
        public let kind: Dependency.Output.Kind = .firstParty

        public init(
            name: String,
            location: Path.Output,
            dependencies: [String: [Dependency.Output]],
            transitiveDependencies: [String: [Dependency.Output]]
        ) {
            self.name = name
            self.location = location
            self.dependencies = dependencies
            self.transitiveDependencies = transitiveDependencies
        }

        var reduced: ReducedOutput {
            return .init(
                name: name,
                location: location
            )
        }
    }

    /// A reduced representation of a first party module used for creating the template context
    /// The main reason for using this type instead of the full Output type is performance
    public struct ReducedOutput: Codable, Hashable {
        /// The name of the first party module
        public let name: String
        /// The location of the first party module
        public let location: Path.Output
        /// The kind of dependency that this module represents
        public let kind: Dependency.Output.Kind = .firstParty

        public init(
            name: String,
            location: Path.Output
        ) {
            self.name = name
            self.location = location
        }
    }
}


