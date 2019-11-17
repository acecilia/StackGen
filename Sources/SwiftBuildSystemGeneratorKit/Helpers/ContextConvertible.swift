import Foundation
import Path

public protocol ContextConvertible: DictionaryConvertible {
    func asContext(basePath: Path?, globals: Globals) throws -> [String: Any]
}

extension ContextConvertible where Self: Encodable {
    public func asContext(basePath: Path?, globals: Globals) throws -> [String: Any] {
        let mainObject = try asDictionary(basePath: basePath)
        let globals = ["globals": try globals.asDictionary(basePath: basePath)]
        let context = mainObject.merging(globals) { current, _ in
            current
        }
        return context
    }
}
