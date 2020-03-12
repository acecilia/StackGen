import Foundation
import Path

public protocol ContextConvertible: DictionaryConvertible {
    func asContext(basePath: Path, globalContext: GlobalContext) throws -> [String: Any]
}

extension ContextConvertible where Self: Encodable {
    public func asContext(basePath: Path, globalContext: GlobalContext) throws -> [String: Any] {
        let mainObject = try asDictionary(basePath: basePath)
        let globalDict = try globalContext.asDictionary(basePath: basePath)
        let context = mainObject.merging(globalDict) { current, _ in
            current
        }
        return context
    }
}
