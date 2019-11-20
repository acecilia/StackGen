import Foundation
import Path

public protocol ContextConvertible: DictionaryConvertible {
    func asContext(basePath: Path?) throws -> [String: Any]
}

extension ContextConvertible where Self: Encodable {
    public func asContext(basePath: Path?) throws -> [String: Any] {
        return try asDictionary(basePath: basePath)
    }
}
