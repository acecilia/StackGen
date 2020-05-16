import Foundation
import Path
import StringCodable
import Yams

public struct BsgFile: AutoCodable {
    public static let fileName = "bsgfile.yml"
    public static let defaultCustom: [String: StringCodable] = [:]
    public static let defaultFirstPartyModules: [FirstPartyModule.Input] = []
    public static let defaultThirdPartyModules: [ThirdPartyModule.Input] = []
    public static let defaultOptions: Options.BsgFile = Options.BsgFile()

    public let custom: [String: StringCodable]
    public let firstPartyModules: [FirstPartyModule.Input]
    public let thirdPartyModules: [ThirdPartyModule.Input]
    public let options: Options.BsgFile

    static func resolve() throws -> BsgFile {
        let bsgFilePath = cwd/BsgFile.fileName
        if bsgFilePath.exists {
            let bsgFileContent = try String(contentsOf: cwd/BsgFile.fileName)
            return try YAMLDecoder().decode(from: bsgFileContent, userInfo: [.relativePath: cwd])
        } else {
            return try YAMLDecoder().decode(from: "{}", userInfo: [.relativePath: cwd])
        }
    }
}
