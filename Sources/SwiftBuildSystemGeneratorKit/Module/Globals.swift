import Foundation

public struct Globals: Codable, DictionaryConvertible {
    public static let defaultSupportPath = "SupportingFiles"

    public let bundleIdPrefix: String
    public let version: String
    public let supportPath: String

    public init(yaml: Yaml) {
        self.bundleIdPrefix = yaml.bundleIdPrefix
        self.version = yaml.version
        self.supportPath = yaml.supportPath ?? Self.defaultSupportPath
    }
}

extension Globals {
    public struct Yaml: Codable {
        public let bundleIdPrefix: String
        public let version: String
        public let supportPath: String?
    }
}
