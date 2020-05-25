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
    public struct Middleware {
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
