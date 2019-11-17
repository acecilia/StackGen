import Foundation

public struct Globals: Codable, DictionaryConvertible {
    public let bundleIdPrefix: String
    public let supportPath: String

    public init(bundleIdPrefix: String, supportPath: String) {
        self.bundleIdPrefix = bundleIdPrefix
        self.supportPath = supportPath
    }
}
