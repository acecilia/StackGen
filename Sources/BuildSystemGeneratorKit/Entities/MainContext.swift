import Foundation
import Path
import StringCodable

public struct MainContext: Codable {
    public let custom: [String: StringCodable]
    public let firstPartyModules: [FirstPartyModule.Output]
    public let thirdPartyModules: [ThirdPartyModule.Output]
    public let global: Global
    public let module: FirstPartyModule.Output?

    public init(
        custom: [String: StringCodable],
        firstPartyModules: [FirstPartyModule.Output],
        thirdPartyModules: [ThirdPartyModule.Output],
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
