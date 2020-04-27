import Foundation
import Path
import StringCodable

public struct MainContext: Codable {
    public let custom: [String: StringCodable]
    public let firstPartyModules: [FirstPartyModule.Output]
    public let thirdPartyModules: [ThirdPartyModule.Output]
    public let global: Global
    public let module: FirstPartyModule.Output?

    public func render(_ basePath: Path) throws -> [String: Any] {
        var context = try asDictionary(basePath)
        if basePath != cwd {
            // Relative to root
            context["rr"] = try asDictionary(cwd)
        }
        if let modulePath = module?.path, basePath != modulePath {
            // Relative to module
            context["rm"] = try asDictionary(cwd)
        }
        return context
    }
}

