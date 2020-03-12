import Foundation
import Version
import Path

public var cwd: Path {
    Path(Path.cwd)
}

public struct Global: Codable, AutoDecodable, DictionaryConvertible {
    public static let defaultIgnore: [Path] = []
    public let ignore: [Path]
}
