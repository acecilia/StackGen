import Foundation
import Path

public struct UnexpectedError: Error, ErrorInterface {
    public let description: String
    public let fileName: String
    public let line: Int

    public init(_ description: String, file: String = #file, line: Int = #line) {
        self.description = description
        self.fileName = URL(fileURLWithPath: file).lastPathComponent
        self.line = line
    }
}
