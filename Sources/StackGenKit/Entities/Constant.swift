import Foundation
import Path

/// Constants used across the codebase
public enum Constant {
    /// The default name for the stackgen file
    public static let stackGenFileName = "stackgen.yml"
    /// The version of the current StackGen binary
    public static let version = "0.0.3"
    /// The temporary directory to use, if needed
    public static let tmpDir: Path = Path(NSTemporaryDirectory())!.join("stackgen-\(version)")
}
