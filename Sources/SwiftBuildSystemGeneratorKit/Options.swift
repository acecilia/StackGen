import Foundation
import Path

public struct Options {
    public static let defaultFileName = "module.yml"
    public static let defaultTemplatesPath = "Templates"
    public static let defaultGenerateXcodeProject = false

    public let rootPath: Path
    public let reporter: ReporterInterface
    public let fileName: String
    public let templatePath: String
    public let generateXcodeProject: Bool

    public init(
        yaml: Yaml?,
        rootPath: Path,
        reporter: ReporterInterface
    ) {
        self.rootPath = rootPath
        self.reporter = reporter
        self.fileName = yaml?.fileName ?? Self.defaultFileName
        self.templatePath = yaml?.templatePath ?? Self.defaultTemplatesPath
        self.generateXcodeProject = yaml?.generateXcodeProject ?? Self.defaultGenerateXcodeProject
    }
}

extension Options {
    public struct Yaml: Codable {
        public let fileName: String?
        public let templatePath: String?
        public let generateXcodeProject: Bool?

        public init(
            fileName: String?,
            templatePath: String?,
            generateXcodeProject: Bool?
        ) {
            self.fileName = fileName
            self.templatePath = templatePath
            self.generateXcodeProject = generateXcodeProject
        }

        public func merge(with yaml: Yaml?) -> Yaml {
            return Yaml(
                fileName: fileName ?? yaml?.fileName,
                templatePath: templatePath ?? yaml?.templatePath,
                generateXcodeProject: generateXcodeProject ?? yaml?.generateXcodeProject
            )
        }
    }
}
