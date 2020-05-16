import Foundation
import Path

public var cwd: Path {
    get {
        guard let cwd = _cwd else {
            fatalError("The current working directory must be set before using it")
        }
        return cwd
    }
    set { _cwd = newValue }
}

private var _cwd: Path?
