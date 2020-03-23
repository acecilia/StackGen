import Foundation

public struct TemplateFile: AutoCodable {
    public static let defaultSubdir = ""

    public let name: String
    public let context: Context
    public let outputLevel: OutputLevel
    public let subdir: String
    public let content: String
}

public enum Context: String, AutoCodable {
    case global
    case module
}

public enum OutputLevel: String, AutoCodable {
    case root
    case module
}
