import Foundation
import Path
import StringCodable

/// A namespace grouping the entities representing the context to be passed to the templates
public struct Context: Codable {
    /// The initial representation of the context that will be passed to the templates
    public struct Input {
        public let custom: [String: StringCodable]
        public let firstPartyModules: [FirstPartyModule.Output]
        public let firstPartyModuleNames: [String]
        public let thirdPartyModules: [ThirdPartyModule.Output]
        public let thirdPartyModuleNames: [String]
        public let templatesFilePath: Path

        public init(
            custom: [String: StringCodable],
            firstPartyModules: [FirstPartyModule.Output],
            thirdPartyModules: [ThirdPartyModule.Output],
            templatesFilePath: Path
        ) {
            self.custom = custom
            self.firstPartyModules = firstPartyModules
            self.firstPartyModuleNames = firstPartyModules.map { $0.name }
            self.thirdPartyModules = thirdPartyModules
            self.thirdPartyModuleNames = thirdPartyModules.map { $0.name }
            self.templatesFilePath = templatesFilePath
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
        /// The custom values defined in the stackgen.yml file
        public let custom: [String: StringCodable]
        /// A list of the first party modules defined in the stackgen.yml file
        public let firstPartyModules: [String]
        /// A list of the third party modules defined in the stackgen.yml file
        public let thirdPartyModules: [String]
        /// Several useful global values
        public let global: Global
        /// The current module that is passed to the template, if any
        public let module: FirstPartyModule.Output?

        public init(
            custom: [String: StringCodable],
            firstPartyModules: [String],
            thirdPartyModules: [String],
            global: Global,
            module: FirstPartyModule.Output?
        ) {
            self.custom = custom
            self.firstPartyModules = firstPartyModules
            self.thirdPartyModules = thirdPartyModules
            self.global = global
            self.module = module
        }
    }
}
