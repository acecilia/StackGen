import Foundation
import Path

extension Encodable {
    func parseAsAny(_ basePath: Path) throws -> Any {
        let encoder = JSONEncoder()
        encoder.userInfo[.relativePath] = basePath

        let data = try encoder.encode(self)
        return  try JSONSerialization.jsonObject(with: data)
    }
}

@propertyWrapper
public class CacheEncoding<T: Codable> {
    public let wrappedValue: T
    private var cache: [Path: Any] = [:]

    public init(_ wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    func parseAsAny(_ basePath: Path) throws -> Any {
        if let cachedDict = cache[basePath] {
            return cachedDict
        } else {
            let parsedAny = try wrappedValue.parseAsAny(basePath)
            cache[basePath] = parsedAny
            return parsedAny
        }
    }

    public var projectedValue: CacheEncoding { self }
}

