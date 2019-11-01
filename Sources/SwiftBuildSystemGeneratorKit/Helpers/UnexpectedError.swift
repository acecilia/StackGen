import Foundation

public struct UnexpectedError: Error, CustomStringConvertible {
    public let description: String

    public init(_ description: String, file: String = #file, line: Int = #line) {
        self.description = "\(description). File: \(file):\(line)"
    }
}

// To print a proper error when throwing
// See: https://stackoverflow.com/questions/39176196/how-to-provide-a-localized-description-with-an-error-type-in-swift
extension UnexpectedError: LocalizedError {
    public var errorDescription: String? {
        return description
    }
}
