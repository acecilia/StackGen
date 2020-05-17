import Foundation
import Path
import StringCodable

public struct Context: Codable {
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

    public struct Output: Codable {
        public let custom: [String: StringCodable]
        public let firstPartyModules: [String]
        public let thirdPartyModules: [String]
        public let global: Global
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
