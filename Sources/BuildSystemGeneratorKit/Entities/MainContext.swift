import Foundation
import Path
import StringCodable

public struct MainContext: Codable {
    public let global: Global
    public let custom: [String: StringCodable]
    public let firstPartyModules: [FirstPartyModule.Output]
    public let thirdPartyModules: [ThirdPartyModule.Output]

    public func render(_ basePath: Path, for module: FirstPartyModule.Output? = nil) throws -> [String: Any] {
        var context = try _render(basePath, for: module)
        if basePath != cwd {
            context["rr"] = try _render(cwd, for: module)
        }
        if let modulePath = module?.path, basePath != modulePath {
            context["rm"] = try _render(cwd, for: module)
        }
        return context
    }

    private func _render(_ basePath: Path, for module: FirstPartyModule.Output? = nil) throws -> [String: Any] {
        var context = try self.asDictionary(basePath)
        context["module"] = try module?.asDictionary(basePath)
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

