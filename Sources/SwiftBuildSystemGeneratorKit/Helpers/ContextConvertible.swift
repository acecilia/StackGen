import Foundation
import Path

public protocol ContextConvertible: DictionaryConvertible {
    func asContext(basePath: Path, globals: RawWrapper<Global>) throws -> [String: Any]
}

extension ContextConvertible where Self: Encodable {
    public func asContext(basePath: Path, globals: RawWrapper<Global>) throws -> [String: Any] {
        let mainObject = try asDictionary(basePath: basePath)
        let globalsDict = ["globals": try globals.asDictionary(basePath: basePath)]
        let context = mainObject.merging(globalsDict) { current, _ in
            current
        }
        return context
    }
}
