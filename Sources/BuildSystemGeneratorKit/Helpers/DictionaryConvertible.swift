import Foundation
import Path

/// https://stackoverflow.com/questions/45209743/how-can-i-use-swift-s-codable-to-encode-into-a-dictionary
public protocol DictionaryConvertible {
    func asDictionary(_ basePath: Path) throws -> [String: Any]
}

extension DictionaryConvertible where Self: Encodable {
    public func asDictionary(_ basePath: Path) throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.userInfo[.relativePath] = basePath

        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw UnexpectedError("Could not convert the object to a dictionary")
        }
        return dictionary
    }
}
