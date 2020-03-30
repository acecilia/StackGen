import Foundation

public struct TemplateFile: AutoCodable {
    public static let defaultSubdir = ""
    public static let defaultModuleFilter: RegularExpression = ".*"

    public let name: String
    public let mode: Mode
    public let subdir: String
    public let moduleFilter: RegularExpression
    public let content: String
}

public extension TemplateFile {
    enum Mode: String, AutoCodable {
        case module
        case moduleToRoot
        case root
    }
}

