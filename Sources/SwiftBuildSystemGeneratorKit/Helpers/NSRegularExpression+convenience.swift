import Foundation

// Source: https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift

extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }

    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }

    func matches(in string: String) -> [String] {
        let results = matches(in: string, range: NSRange(location: 0, length: string.count))
        return results.map { String(string[Range($0.range, in: string)!]) }
    }
}
