import Foundation
import Path
import StringCodable
import Yams

public struct StackGenFile: AutoCodable {
    public static let fileName = "stackgen.yml"
    public static let defaultCustom: [String: StringCodable] = [:]
    public static let defaultFirstPartyModules: [FirstPartyModule.Input] = []
    public static let defaultThirdPartyModules: [ThirdPartyModule.Input] = []
    public static let defaultOptions: Options.StackGenFile = Options.StackGenFile()

    public let custom: [String: StringCodable]
    public let firstPartyModules: [FirstPartyModule.Input]
    public let thirdPartyModules: [ThirdPartyModule.Input]
    public let options: Options.StackGenFile

    static func resolve(_ env: Env) throws -> StackGenFile {
        let stackGenFilePath = env.cwd/StackGenFile.fileName

        if stackGenFilePath.exists {
            let stackGenFileContent = try String(contentsOf: stackGenFilePath)
            return try YAMLDecoder().decode(from: stackGenFileContent, userInfo: [.relativePath: env.root])
        } else {
            return try YAMLDecoder().decode(from: "{}", userInfo: [.relativePath: env.root])
        }
    }
}
