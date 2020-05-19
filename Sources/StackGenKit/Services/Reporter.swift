import Foundation
import Path

/// The service used to format the prints
public class Reporter {
    public let silent: Bool

    public init(silent: Bool = false) {
        self.silent = silent
    }

    public func start(_ arguments: [String], _ cwd: Path) {
        Swift.print("🌱 Working directory: \(cwd)")
        let arguments = arguments.joined(separator: " ")
        Swift.print("🌱 Arguments: \(arguments.isEmpty ? "None" : arguments)")
    }

    public func info(_ emoji: Emoji, _ string: String) {
        if silent == false  {
            Swift.print("\(emoji.character) \(string.capitalizingFirstLetter())")
        }
    }


    public func warning(_ string: String) {
        Swift.print("⚠️ Warning: \(string)")
    }

    public func formatAsError(_ string: String) -> String {
        return "💥 Error: \(string)"
    }

    public func end() {
        Swift.print("✅ Done")
    }
}

extension Reporter {
    public enum Emoji {
        case sparkles
        case books
        case wrench
        case pageFacingUp
        case broom
    }
}

private extension Reporter.Emoji {
    var character: Character {
        switch self {
        case .sparkles:
            return "✨"
        case .books:
            return "📚"
        case .wrench:
            return "🔧"
        case .pageFacingUp:
            return "📄"
        case .broom:
            return "🧹"
        }
    }
}
