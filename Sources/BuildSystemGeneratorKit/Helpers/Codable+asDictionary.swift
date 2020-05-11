import Foundation
import MoreCodable
import Path

#if true // Experimental: turning this on will enable caching of the encoded elements that are hashable
private let cache = DictionaryCachableEncoder.DefaultCache()

public extension Encodable {
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
