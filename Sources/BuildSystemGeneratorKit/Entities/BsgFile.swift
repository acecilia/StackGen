import Foundation
import Path
import StringCodable

public struct BsgFile: AutoCodable {
    public static let fileName = "bsgfile.yml"
    public static let defaultCustom: [String: StringCodable] = [:]
    public static let defaultModules: [FirstPartyModule.Input] = []
    public static let defaultVersionSources: [Path] = []

    public let custom: [String: StringCodable]
    public let modules: [FirstPartyModule.Input]
    public let versionSources: [Path]
    public let options: Options
}
