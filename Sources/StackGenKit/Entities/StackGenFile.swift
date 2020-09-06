import Foundation
import Path
import StringCodable
import Yams

/// The representation of the stackgen.yml file
public struct StackGenFile: AutoCodable {
    public static let defaultGlobal: [String: StringCodable] = [:]
    public static let defaultFirstPartyModules: [FirstPartyModule.Input] = []
    public static let defaultThirdPartyModules: [ThirdPartyModule.Input] = []
    public static let defaultAvailableTemplateGroups: [String: [TemplateSpec.Input]] = [:]
    public static let defaultLintOptions: LintOptions = .init()

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
    /// The lint options to use
    public let lintOptions: LintOptions

    public init(
        options: Options.StackGenFile = Options.StackGenFile(),
        global: [String: StringCodable] = defaultGlobal,
        firstPartyModules: [FirstPartyModule.Input] = defaultFirstPartyModules,
        thirdPartyModules: [ThirdPartyModule.Input] = defaultThirdPartyModules,
        availableTemplateGroups: [String: [TemplateSpec.Input]] = defaultAvailableTemplateGroups,
        lintOptions: LintOptions = defaultLintOptions
    ) {
        self.options = options
        self.global = global
        self.firstPartyModules = firstPartyModules
        self.thirdPartyModules = thirdPartyModules
        self.availableTemplateGroups = availableTemplateGroups
        self.lintOptions = lintOptions
    }

    public static func resolve(_ env: inout Env) throws -> StackGenFile? {
        let stackGenFilePath = env.cwd/Constant.stackGenFileName

        guard stackGenFilePath.exists else {
            return nil
        }

        func decode() throws -> StackGenFile {
            let stackGenFileContent = try String(contentsOf: stackGenFilePath)
            return try YAMLDecoder().decode(
                from: stackGenFileContent,
                userInfo: [.relativePath: env.root]
            )
        }

        let stackGenFile = try decode()
        if let root = stackGenFile.options.root {
            env.root = Path(root) ?? env.cwd/root
            // If the root is not the cwd, parse again the stackgenFile in
            // order to get the right relative paths
            return try decode()
        } else {
            return stackGenFile
        }
    }
}
