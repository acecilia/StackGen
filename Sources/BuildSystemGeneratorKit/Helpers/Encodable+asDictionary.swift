import Foundation
import MoreCodable
import Path

#if true // Experimental: turning this on will enable caching of the encoded elements that are hashable
private let cache = DictionaryCachableEncoder.DefaultCache()

extension Encodable {
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
extension Encodable {
    func asDictionary(_ basePath: Path) throws -> [String: Any] {
        let encoder = DictionaryEncoder()
        encoder.userInfo[.relativePath] = basePath
        return try encoder.encode(self)
    }
}
#endif

