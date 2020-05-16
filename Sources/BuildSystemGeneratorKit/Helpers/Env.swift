import Foundation
import Path

public struct Env {
    public let cwd: Path
    public var topLevel: Path
    public let reporter: ReporterInterface
    public let writer: Writer

    public init(
        cwd: Path = Path(Path.cwd),
        topLevel: Path = Path(Path.cwd),
        reporter: ReporterInterface = DefaultReporter(),
        writer: Writer = Writer()
    ) {
        self.cwd = cwd
        self.topLevel = topLevel
        self.reporter = reporter
        self.writer = writer
    }
}
