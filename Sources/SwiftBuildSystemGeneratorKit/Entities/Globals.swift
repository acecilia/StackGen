import Foundation
import Version
import Path

public struct Globals: Codable, DictionaryConvertible {
    public static let defaultSupportPath = "SupportingFiles"
    public static let defaultFolderStructure: FolderStructure = .gradle

    public let bundleIdPrefix: String
    public let version: Version
    public let swiftVersion: Version
    public let folderStructure: FolderStructure
    public let supportPath: String
    public let ignore: [Path]
    public let workspacePath: Path

    public init(_ yaml: Yaml, templatePath: Path) {
        self.bundleIdPrefix = yaml.bundleIdPrefix
        self.version = yaml.version
        self.swiftVersion = yaml.swiftVersion
        self.folderStructure = yaml.folderStructure ?? Self.defaultFolderStructure
        self.supportPath = yaml.supportPath ?? Self.defaultSupportPath
        self.ignore = (yaml.ignore ?? []) + [templatePath]
        self.workspacePath = cwd
    }
}

extension Globals {
    public struct Yaml: Codable {
        public let bundleIdPrefix: String
        public let version: Version
        public let swiftVersion: Version
        public let folderStructure: FolderStructure?
        public let supportPath: String?
        public let ignore: [Path]?
    }
}
