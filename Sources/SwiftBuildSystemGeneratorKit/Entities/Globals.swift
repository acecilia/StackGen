import Foundation
import Version
import Path

public struct Globals: Codable, DictionaryConvertible {
    public static let defaultSupportPath = "SupportingFiles"
    public static let defaultFolderStructure: FolderStructure = .gradle

    public let bundleIdPrefix: String
    public let version: Version
    public let folderStructure: FolderStructure
    public let supportPath: String

    public init(_ yaml: Yaml) {
        self.bundleIdPrefix = yaml.bundleIdPrefix
        self.version = yaml.version
        self.folderStructure = yaml.folderStructure ?? Self.defaultFolderStructure
        self.supportPath = yaml.supportPath ?? Self.defaultSupportPath
    }
}

extension Globals {
    public struct Yaml: Codable {
        public let bundleIdPrefix: String
        public let version: Version
        public let folderStructure: FolderStructure?
        public let supportPath: String?
    }
}
