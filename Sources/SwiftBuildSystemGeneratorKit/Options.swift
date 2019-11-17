import Foundation
import Path

public struct Options {
    public let rootPath: Path
    public let reporter: ReporterInterface
    public let fileName: String
    public let templatePath: String
    public let generateXcodeProject: Bool

    public init(
        yaml: Yaml?,
        rootPath: Path,
        reporter: ReporterInterface,
        fileName: String? = nil,
        templatePath: String? = nil,
        generateXcodeProject: Bool? = nil
    ) {
        self.rootPath = rootPath
        self.reporter = reporter
        self.fileName = yaml?.fileName ?? fileName ?? "module.yml"
        self.templatePath = yaml?.templatePath ?? templatePath ?? "Templates"
        self.generateXcodeProject = yaml?.generateXcodeProject ?? generateXcodeProject ?? false
    }
}

extension Options {
    public struct Yaml: Codable {
        public let fileName: String?
        public let templatePath: String?
        public let generateXcodeProject: Bool?
    }
}
