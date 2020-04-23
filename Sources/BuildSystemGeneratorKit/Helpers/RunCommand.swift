import Foundation
import Path
import SwiftCLI

@discardableResult
public func run(_ cmd: String, directory: Path? = nil) throws -> String {
    do {
        return try Task.capture(bash: cmd, directory: directory?.string).stdout
    } catch let error as CaptureError {
        print(error.captured.stdout)
        print(error.captured.stderr)
        throw error
    }
}
