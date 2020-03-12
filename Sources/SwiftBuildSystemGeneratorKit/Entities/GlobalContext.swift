import Foundation

public struct GlobalContext: Encodable, DictionaryConvertible {
    @RawWrapper
    private(set) var global: Global
    let modules: [Target.Output]
}
