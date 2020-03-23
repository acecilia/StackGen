import Foundation

public struct MainContext: Codable, DictionaryConvertible {
    public let global: [String: String]
    public let firstPartyModules: [FirstPartyModule.Output]
    public let thirdPartyModules: [ThirdPartyModule.Output]

    public func asDictionary(_ basePath: Path, for module: FirstPartyModule.Output) throws -> [String: Any] {
        let globalContext = try self.asDictionary(basePath)
        let moduleContext = try module.asDictionary(basePath)
        return globalContext.merging(["module": moduleContext]) { current, _ in
            current
        }
    }
}
