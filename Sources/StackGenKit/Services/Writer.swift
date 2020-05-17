import Foundation
import Path

public class Writer {
    public private(set) var writtenFiles: [Path] = []
    public let shouldWrite: Bool

    public init(shouldWrite: Bool = true) {
        self.shouldWrite = shouldWrite
    }
    
    public func write(_ string: String, to path: Path, with posixPermissions: Any?) throws {
        writtenFiles.append(path)
        guard shouldWrite else { return }

        if string.isEmpty {
            try path.delete()
        } else {
            try string.write(to: path)
            if let posixPermissions = posixPermissions {
                try FileManager.default.setAttributes(
                    [.posixPermissions: posixPermissions],
                    ofItemAtPath: path.string
                )
            }
        }
    }
}
