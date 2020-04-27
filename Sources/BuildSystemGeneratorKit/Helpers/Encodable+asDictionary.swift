import Foundation
import MoreCodable
import Path

private let cache = DictionaryCachableEncoder.DefaultCache()

/// https://stackoverflow.com/questions/45209743/how-can-i-use-swift-s-codable-to-encode-into-a-dictionary
extension Encodable {
    func asDictionary(_ basePath: Path) throws -> [String: Any] {
        let encoder = DictionaryEncoder()
        // encoder.cache = cache
        encoder.userInfo[.relativePath] = basePath
//        encoder.userInfoHasher = { userInfo in
//            return userInfo[.relativePath] as? Path
//        }

        return try encoder.encode(self)
    }
}
