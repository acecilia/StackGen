import Foundation
import Path

/// https://stackoverflow.com/questions/45209743/how-can-i-use-swift-s-codable-to-encode-into-a-dictionary
protocol DictionaryConvertible {
    func asDictionary(basePath: Path?) throws -> [String: Any]
}

extension DictionaryConvertible where Self: Encodable {
    func asDictionary(basePath: Path?) throws -> [String: Any] {
        let encoder = JSONEncoder()
        if let basePath = basePath {
            encoder.userInfo[.relativePath] = basePath
        }
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw UnexpectedError("Could not convert the object to a dictionary")
        }
        return dictionary
    }
}
