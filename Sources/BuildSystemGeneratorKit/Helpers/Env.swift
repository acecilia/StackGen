import Foundation
import Path

public struct Env {
    public let cwd: Path
    public var root: Path
    public let reporter: Reporter
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
