import Foundation
import Path

public struct Options {
    public let rootPath: Path
    public let reporter: ReporterInterface
    public let fileName: String
    public let templatePath: String
    public let generateXcodeProject: Bool

    public init(
        rootPath: Path,
        reporter: ReporterInterface,
        fileName: String? = nil,
        templatePath: String? = nil,
        generateXcodeProject: Bool? = nil
    ) {
        self.rootPath = rootPath
        self.reporter = reporter
        self.fileName = fileName ?? "Module.yml"
        self.templatePath = templatePath ?? "Templates"
        self.generateXcodeProject = generateXcodeProject ?? false
    }
}
