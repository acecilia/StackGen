import Foundation

public struct Globals: Codable, DictionaryConvertible {
    public let bundleIdPrefix: String
    public let supportPath: String

    public init(yaml: Yaml) {
        self.bundleIdPrefix = yaml.bundleIdPrefix
        self.supportPath = yaml.supportPath ?? "SupportingFiles"
    }
}

extension Globals {
    public struct Yaml: Codable {
        public let bundleIdPrefix: String
        public let supportPath: String?
    }
}
