import Foundation

public struct Global: Codable, AutoDecodable, DictionaryConvertible {
    public static let defaultSupportPath = "SupportingFiles"
    public static let defaultFolderStructure: FolderStructure = .gradle
    public static let defaultIgnore: [Path] = []

    public let version: Version
    public let folderStructure: FolderStructure
    public let supportPath: String
    public let ignore: [Path]
}
