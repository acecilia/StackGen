import Foundation
import Path
import StringCodable

/// A namespace grouping the entities representing the context to be passed to the templates
public enum Context {
    /// The initial representation of the context that will be passed to the templates
    public struct Input {
        /// The global values defined in the stackgen.yml file
        public let global: [String: StringCodable]
        /// A list of the modules defined in the stackgen.yml file
        public let modules: [Module.Output]

        public init(
            global: [String: StringCodable],
            modules: [Module.Output]
        ) {
            self.global = global
            self.modules = modules
        }
    }

    /// The final representation of the context that will be passed to the templates
    public struct Output: Codable {
        /// The environment of the Context
        public let env: Env
        /// The global values defined in the stackgen.yml file
        public let global: [String: StringCodable]
        /// A list of the modules defined in the stackgen.yml file
        public let modules: [Module.Output]
        /// The current module that is passed to the template, if any
        public let module: FirstPartyModule.Output?

        public init(
            env: Env,
            global: [String: StringCodable],
            modules: [Module.Output],
            module: FirstPartyModule.Output?
        ) {
            self.env = env
            self.global = global
            self.modules = modules
            self.module = module
        }
    }

    /// The environment for a Context
    public struct Env: Codable, Hashable {
        /// The root path from where the tool runs
        public let root: Path
        /// The output path of the file resulting from rendering a template with a context
        public let output: Path

        public init(
            root: Path,
            output: Path
        ) {
            self.root = root
            self.output = output
        }
    }
}
