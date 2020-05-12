import Foundation

public protocol ReporterInterface {
    func start(_ arguments: [String])
    func info(_ emoji: Emoji, _ string: String)
    func warning(_ string: String)
    func formatAsError(_ string: String) -> String
    func end(_ status: Int32)
}

public enum Emoji {
    case sparkles
    case books
    case hammer
}
