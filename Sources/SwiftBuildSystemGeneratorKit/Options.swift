import Foundation
import Path

public struct Options {
    public let rootPath: Path
    public let reporter: ReporterInterface
    public let fileName: String

    public init(
        rootPath: Path,
        reporter: ReporterInterface,
        fileName: String? = nil
    ) {
        self.rootPath = rootPath
        self.reporter = reporter
        self.fileName = fileName ?? "module.yml"
    }
}
