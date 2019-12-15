import Foundation
import Path

public protocol ContextConvertible: DictionaryConvertible {
    func asContext(basePath: Path?) throws -> [String: Any]
}

extension ContextConvertible where Self: Encodable {
    public func asContext(basePath: Path?) throws -> [String: Any] {
        let mainObject = try asDictionary(basePath: basePath)
        let globalsDict = ["globals": try Current.$globals.asDictionary(basePath: basePath)]
        let context = mainObject.merging(globalsDict) { current, _ in
            current
        }
        return context
    }
}
