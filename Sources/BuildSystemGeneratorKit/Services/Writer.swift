import Foundation
import Path

public class Writer {
    public private(set) var writtenFiles: [Path] = []
    public let shouldWrite: Bool

    public init(shouldWrite: Bool = true) {
        self.shouldWrite = shouldWrite
    }
    
    public func write(_ string: String, to path: Path) throws {
        writtenFiles.append(path)
        if shouldWrite {
            try string.write(to: path)
        }
    }
}
