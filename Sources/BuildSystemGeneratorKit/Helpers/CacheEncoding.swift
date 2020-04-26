import Foundation
import Path
import DictionaryCachableEncodable

public typealias Cucu<T: Encodable> = DictionaryCachableEncodable<T, CacheKeyResolver, DefaultCache>

public struct CacheKeyResolver: CacheKeyResolverProtocol {
    public init() { }

    public func getKey(_ userInfo: [CodingUserInfoKey : Any]) -> AnyHashable {
        return userInfo[.relativePath] as? Path
    }
}
