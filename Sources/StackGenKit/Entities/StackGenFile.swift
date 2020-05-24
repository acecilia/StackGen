import Foundation
import Path
import StringCodable
import Yams

/// The representation of the stackgen.yml file
public struct StackGenFile: AutoDecodable {
    public static let fileName = "stackgen.yml"

    public static let defaultGlobal: [String: StringCodable] = [:]
    public static let defaultFirstPartyModules: [FirstPartyModule.Input] = []
    public static let defaultThirdPartyModules: [ThirdPartyModule.Input] = []
    public static let defaultAvailableTemplateGroups: [String: [TemplateSpec.Input]] = [:]

    /// The options passed to the tool
    public let options: Options.StackGenFile
    /// A dictionary used to declare global values that can be accessed from all the templates
    public let global: [String: StringCodable]
    /// The first party modules to use
    public let firstPartyModules: [FirstPartyModule.Input]
    /// The third party modules to use
    public let thirdPartyModules: [ThirdPartyModule.Input]
    /// The template groups to use
    public let availableTemplateGroups: [String: [TemplateSpec.Input]]

    public init(
        options: Options.StackGenFile = Options.StackGenFile(version: VERSION),
        global: [String: StringCodable] = defaultGlobal,
        firstPartyModules: [FirstPartyModule.Input] = defaultFirstPartyModules,
        thirdPartyModules: [ThirdPartyModule.Input] = defaultThirdPartyModules,
        availableTemplateGroups: [String: [TemplateSpec.Input]] = defaultAvailableTemplateGroups
    ) {
        self.options = options
        self.global = global
        self.firstPartyModules = firstPartyModules
        self.thirdPartyModules = thirdPartyModules
        self.availableTemplateGroups = availableTemplateGroups
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
