import Foundation

/// Convenient extensions
/// Source: https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift
extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern)")
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

/// A wrapper around NSRegularExpression that can be encoded and decoded
@propertyWrapper
public struct RegularExpression: Codable, ExpressibleByStringLiteral {
    public let wrappedValue: NSRegularExpression

    public init(stringLiteral value: String) {
        self.wrappedValue = NSRegularExpression(value.addingRegexDelimiters)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decodedValue = try container.decode(String.self)
        self.wrappedValue = try NSRegularExpression(pattern: decodedValue.addingRegexDelimiters)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue.pattern)
    }
}

private extension String {
    var addingRegexDelimiters: String {
        return "^\(self)$"
    }
}
