import Foundation
import Path

public extension Encodable {
    func asDictionary(_ basePath: Path) throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.userInfo[.relativePath] = basePath

        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
          throw NSError()
        }
        return dictionary
    }
}
