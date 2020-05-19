import Foundation
import Path
import StringCodable
import Yams

/// The representation of the stackgen.yml file
public struct StackGenFile: AutoCodable {
    public static let fileName = "stackgen.yml"

    public static let defaultCustom: [String: StringCodable] = [:]
    public static let defaultFirstPartyModules: [FirstPartyModule.Input] = []
    public static let defaultThirdPartyModules: [ThirdPartyModule.Input] = []

    /// A dictionary used to declare custom values that can be accessed from all the templates
    public let custom: [String: StringCodable]
    /// The first party modules to use
    public let firstPartyModules: [FirstPartyModule.Input]
    /// The third party modules to use
    public let thirdPartyModules: [ThirdPartyModule.Input]
    /// The options passed to the tool
    public let options: Options.StackGenFile

    public init(
        custom: [String: StringCodable] = defaultCustom,
        firstPartyModules: [FirstPartyModule.Input] = defaultFirstPartyModules,
        thirdPartyModules: [ThirdPartyModule.Input] = defaultThirdPartyModules,
        options: Options.StackGenFile = Options.StackGenFile(version: VERSION)
    ) {
        self.custom = custom
        self.firstPartyModules = firstPartyModules
        self.thirdPartyModules = thirdPartyModules
        self.options = options
    }

    static func resolve(_ env: Env) throws -> StackGenFile {
        let stackgenFilePath = env.cwd/StackGenFile.fileName

        if stackgenFilePath.exists {
            let stackgenFileContent = try String(contentsOf: stackgenFilePath)
            return try YAMLDecoder().decode(
                from: stackgenFileContent,
                userInfo: [.relativePath: env.root]
            )
        } else {
            return StackGenFile()
        }
    }
}
