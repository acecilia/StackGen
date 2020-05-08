import Foundation
import Path
import StringCodable
import MoreCodable

public struct MainContext: Codable {
    public let custom: [String: StringCodable]
    public let firstPartyModules: [FirstPartyModule.Output]
    public let thirdPartyModules: [ThirdPartyModule.Output]
    public let global: Global
    public let module: FirstPartyModule.Output?

    public func render(_ basePath: Path) throws -> [String: Any] {
        return try asDictionary(basePath)
    }
}

#if true // Experimental: turning this on will enable caching of the encoded elements that are hashable
private let cache = DictionaryCachableEncoder.DefaultCache()

private extension Encodable {
    func asDictionary(_ basePath: Path) throws -> [String: Any] {
        let encoder = DictionaryCachableEncoder()
        encoder.cache = cache
        encoder.userInfo[.relativePath] = basePath
        encoder.userInfoHasher = { userInfo in
            return userInfo[.relativePath] as? Path
        }

        return try encoder.encode(self)
    }
}
#else
private extension Encodable {
    func asDictionary(_ basePath: Path) throws -> [String: Any] {
        let encoder = DictionaryEncoder()
        encoder.userInfo[.relativePath] = basePath
        return try encoder.encode(self)
    }
}
#endif
