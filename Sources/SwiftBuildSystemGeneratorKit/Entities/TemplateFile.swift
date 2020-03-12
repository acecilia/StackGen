import Foundation

struct TemplateFile: Codable, AutoCodable {
    static let defaultSubdir = ""

    let name: String
    let context: Context
    let outputLevel: OutputLevel
    let subdir: String
    let content: String
}

enum Context: String, AutoCodable {
    case global
    case module
}

enum OutputLevel: String, AutoCodable {
    case root
    case module
}
