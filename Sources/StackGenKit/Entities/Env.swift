import Foundation
import Path

/// An environment wrapper used to inject dependencies around without
/// polluting the function signatures with multiple parameters
public struct Env {
    /// The current working directory
    public let cwd: Path
    /// The root of the repository to use
    public var root: Path
    /// The reporter used to format the output
    public var reporter: Reporter

    public init(
        cwd: Path = Path(Path.cwd),
        root: Path = Path(Path.cwd),
        reporter: Reporter = Reporter()
    ) {
        self.cwd = cwd
        self.root = root
        self.reporter = reporter
    }
}
