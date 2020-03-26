import Foundation

public struct BsgFile: AutoCodable {
    public static let fileName = "bsgfile"
    public static let defaultCustom: [String: String] = [:]
    public static let defaultModules: [FirstPartyModule.Input] = []
    public static let defaultVersionSources: [Path] = []

    public let custom: [String: String]
    public let modules: [FirstPartyModule.Input]
    public let versionSources: [Path]
    public let options: Options
}
