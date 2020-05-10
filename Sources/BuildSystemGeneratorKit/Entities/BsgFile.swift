import Foundation
import Path
import StringCodable

public struct BsgFile: AutoCodable {
    public static let fileName = "bsgfile.yml"
    public static let defaultCustom: [String: StringCodable] = [:]
    public static let defaultFirstPartyModules: [FirstPartyModule.Input] = []
    public static let defaultThirdPartyModules: [ThirdPartyModule.Input] = []
    public static let defaultVersionSources: [Path] = []
    public static let defaultOptions: Options.Input = Options.Input()

    public let custom: [String: StringCodable]
    public let firstPartyModules: [FirstPartyModule.Input]
    public let thirdPartyModules: [ThirdPartyModule.Input]
    public let versionSources: [Path]
    public let options: Options.Input
}
