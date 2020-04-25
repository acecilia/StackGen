import Foundation
import Path
import StringCodable

public struct MainContext {
    // Constants
    @CacheEncoding public var custom: [String: StringCodable]
    @CacheEncoding public var firstPartyModules: [FirstPartyModule.Output]
    @CacheEncoding public var thirdPartyModules: [ThirdPartyModule.Output]

    // Variables
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

    func asDictionary(_ basePath: Path) throws -> [String: Any] {
        return [
            "custom": try $custom.parseAsAny(basePath),
            "firstPartyModules": try $firstPartyModules.parseAsAny(basePath),
            "thirdPartyModules": try $thirdPartyModules.parseAsAny(basePath),
            "global": try global.parseAsAny(basePath),
            "module": try module?.parseAsAny(basePath) as Any,
        ]
    }
}
