import Foundation
import Mustache

public struct UnexpectedError: Error, CustomStringConvertible {
    public let description: String

    public init(_ description: String, file: String = #file, line: Int = #line) {
        self.description = "\(description). File: \(file):\(line)"
    }
}
