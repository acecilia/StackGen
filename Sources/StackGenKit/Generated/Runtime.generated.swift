import SwiftTemplateEngine

let stackgenRuntimeFiles: [SwiftTemplate.File] = [
    .init(
        name: "Context.swift",
        content: """
import Foundation
import Path
import StringCodable

/// A namespace grouping the entities representing the context to be passed to the templates
public enum Context {
    /// The initial representation of the context that will be passed to the templates
    public struct Input {
        public let global: [String: StringCodable]
        public let firstPartyModules: [FirstPartyModule.Output]
        public let firstPartyModuleNames: [String]
        public let thirdPartyModules: [ThirdPartyModule.Output]
        public let thirdPartyModuleNames: [String]

        public init(
            global: [String: StringCodable],
            firstPartyModules: [FirstPartyModule.Output],
            thirdPartyModules: [ThirdPartyModule.Output]
        ) {
            self.global = global
            self.firstPartyModules = firstPartyModules
            self.firstPartyModuleNames = firstPartyModules.map { $0.name }
            self.thirdPartyModules = thirdPartyModules
            self.thirdPartyModuleNames = thirdPartyModules.map { $0.name }
        }
    }

    /// A middleware representation of the context that will be passed to the templates
    public struct Middleware: Codable {
        public let firstPartyModules: [FirstPartyModule.Output]
        public let thirdPartyModules: [ThirdPartyModule.Output]
        public let output: Output

        public init(
            firstPartyModules: [FirstPartyModule.Output],
            thirdPartyModules: [ThirdPartyModule.Output],
            output: Output
        ) {
            self.firstPartyModules = firstPartyModules
            self.thirdPartyModules = thirdPartyModules
            self.output = output
        }
    }

    /// The final representation of the context that will be passed to the templates
    public struct Output: Codable {
        /// The environment of the Context
        public let env: Env
        /// The global values defined in the stackgen.yml file
        public let global: [String: StringCodable]
        /// A list of the first party modules defined in the stackgen.yml file
        public let firstPartyModules: [String]
        /// A list of the third party modules defined in the stackgen.yml file
        public let thirdPartyModules: [String]
        /// The current module that is passed to the template, if any
        public let module: FirstPartyModule.Output?

        public init(
            env: Env,
            global: [String: StringCodable],
            firstPartyModules: [String],
            thirdPartyModules: [String],
            module: FirstPartyModule.Output?
        ) {
            self.env = env
            self.global = global
            self.firstPartyModules = firstPartyModules
            self.thirdPartyModules = thirdPartyModules
            self.module = module
        }
    }

    /// The environment for a Context
    public struct Env: Codable, Hashable {
        /// The root path from where the tool runs
        public let root: Path.Output
        /// The output path of the file resulting from rendering a template with a context
        public let output: Path.Output

        public init(
            root: Path.Output,
            output: Path.Output
        ) {
            self.root = root
            self.output = output
        }
    }
}
"""
    ),
    .init(
        name: "FirstPartyModule.swift",
        content: """
import Foundation
import Path

/// A namespace grouping the entities representing a first party module
public enum FirstPartyModule {
    /// A representation of a first party module to be used inside the stackgen.yml file
    public struct Input: AutoCodable, Hashable {
        static let defaultDependencies: [String: [String]] = [:]

        /// The name of the module
        public var name: String { path.basename() }
        /// The path of the module
        public let path: Path
        /**
         A dictionary representing the dependencies of the module

         You can use any string value you want as key of the dictionary, but in general,
         the keys of the dictionary represent the kind of target. For example:

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

    /// A representation of a first party module that is used in the context
    /// rendered by the templates
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
"""
    ),
    .init(
        name: "ThirdPartyModule.swift",
        content: """
import Foundation
import Path
import StringCodable
import Compose

/// A namespace grouping the entities representing a third party module
public enum ThirdPartyModule {
    /// The representation of a third party module, containing the typed and untyped properties.
    /// This allows to include custom keys-values in the third party modules, on top of the mandatory ones
    /// required by the typed representation. For example, you may want to add the following
    /// custom key-value: `repository: https://github.com/somebody/myThirdPartyModule`
    public typealias Input = Compose<_Input, [String: StringCodable]>
    /// The typed representation of a third party module
    public struct _Input: Codable {
        public let name: String
    }

    /// The representation of a third party module. Used in the context rendered by the templates
    public typealias Output = Compose<_Output, [String: StringCodable]>
    /// The typed representation of a third party module. Used in the context rendered by the templates
    public struct _Output: Codable, Hashable {
        public let name: String
        public let kind: ModuleKind = .thirdParty
    }
}

public extension Compose where Element2 == [String: StringCodable] {
    var dictionary: [String: StringCodable] { _element2 }
}
"""
    ),
    .init(
        name: "ModuleKind.swift",
        content: """
import Foundation

/// The kind of module
public enum ModuleKind: String, Codable, CaseIterable, Comparable {
    case firstParty
    case thirdParty

    public static func < (lhs: Self, rhs: Self) -> Bool {
        return allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}
"""
    ),
    .init(
        name: "Path+Output.swift",
        content: """
import Foundation
import Path

extension Path {
    /// A path representation to be used when a path is needed inside the context
    public struct Output: Codable, Hashable {
        /// The absolut path to the file
        public let path: Path
        /// The corresponding basename
        public let basename: String
        /// The parent path
        public let parent: Path
    }

    public var output: Output {
        return Output(
            path: self,
            basename: self.basename(),
            parent: self.parent
        )
    }
}
"""
    ),
    .init(
        name: "AutoCodable.swift",
        content: """
// MARK: sourcery related

protocol AutoDecodable: Decodable {}
protocol AutoEncodable: Encodable {}
protocol AutoCodable: AutoDecodable, AutoEncodable {}
"""
    ),
]