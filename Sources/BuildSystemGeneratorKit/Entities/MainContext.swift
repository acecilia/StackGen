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

    public func render(_ basePath: Path) throws -> [String: Any] {
        return try asDictionary(basePath)
    }
}

#if false // Experimental: turning this on will enable caching of the encoded elements that are hashable
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
        let encoder = JSONEncoder()
        encoder.userInfo[.relativePath] = basePath

        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
          throw NSError()
        }
        return dictionary
    }

//    func asDictionary(_ basePath: Path) throws -> [String: Any] {
//        let encoder = DictionaryEncoder()
//        encoder.userInfo[.relativePath] = basePath
//        return try encoder.encode(self)
//    }
}
#endif
