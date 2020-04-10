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

/// https://stackoverflow.com/questions/45209743/how-can-i-use-swift-s-codable-to-encode-into-a-dictionary
private extension Encodable {
    func asDictionary(_ basePath: Path) throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.userInfo[.relativePath] = basePath

        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw UnexpectedError("Could not convert the object to a dictionary")
        }
        return dictionary
    }
}
