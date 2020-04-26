import Foundation
import Path
import StringCodable
import DictionaryCachableEncodable

public struct MainContext: Codable {
    // Constants
    @Cucu public var custom: [String: StringCodable]
    @Cucu public var firstPartyModules: [FirstPartyModule.Output]
    @Cucu public var thirdPartyModules: [ThirdPartyModule.Output]

    // Variables
    @Cucu public var global: Global
    @Cucu public var module: FirstPartyModule.Output?

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
        let object = Cucu(wrappedValue: self)

        let encoder = JSONEncoder()
        encoder.userInfo[.relativePath] = basePath
        _ = try? encoder.encode(object)

        let dict = object.lastCached?.dictionaryObject ?? [:]
        return dict
    }
}
