import Foundation
import Version
import Path

public var cwd: Path {
    Path(Path.cwd)
}

public struct Global: Codable, AutoDecodable, DictionaryConvertible {
    public static let defaultSupportPath = "SupportingFiles"
    public static let defaultIgnore: [Path] = []

    public let version: Version
    public let supportPath: String
    public let ignore: [Path]
}
