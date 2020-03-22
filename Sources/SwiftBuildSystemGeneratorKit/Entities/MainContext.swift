import Foundation

public struct MainContext: Codable, DictionaryConvertible {
    @RawWrapper
    public private(set) var global: Global
    public let modules: [Target.Output]
    public let artifacts: [Artifact.Output]

    public func asDictionary(_ basePath: Path, for module: Target.Output) throws -> [String: Any] {
        let globalContext = try self.asDictionary(basePath)
        let moduleContext = try module.asDictionary(basePath)
        return globalContext.merging(["module": moduleContext]) { current, _ in
            current
        }
    }
}
