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
    public let reporter: Reporter
    /// The type used to write files to disk
    public let writer: Writer

    public init(
        cwd: Path = Path(Path.cwd),
        root: Path = Path(Path.cwd),
        reporter: Reporter = Reporter(),
        writer: Writer = Writer()
    ) {
        self.cwd = cwd
        self.root = root
        self.reporter = reporter
        self.writer = writer
    }
}
