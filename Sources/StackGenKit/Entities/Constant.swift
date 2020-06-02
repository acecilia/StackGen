import Foundation
import Path

/// Constants used across the codebase
public enum Constant {
    /// The default name for the stackgen file
    public static let stackGenFileName = "stackgen.yml"
    /// The version of the current StackGen binary
    public static let version = "0.0.2"
    /// The temporary directory to use
    public static let tempDir: Path = Path(NSTemporaryDirectory())!.join("stackgen-\(version)")
}
