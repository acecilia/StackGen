import Foundation
import Path

public struct Options {
    public static let defaultFileName = "module.yml"
    public static let defaultTemplatesPath = "Templates"
    public static let defaultGenerateXcodeProject = false
    public static let defaultGenerateXcodeWorkspace = false
    public static let defaultCarthagePath = cwd

    public let fileName: String
    public let templatePath: Path
    public let generateXcodeProject: Bool
    public let generateXcodeWorkspace: Bool
    public let generators: [Generator]
    public let converters: [Converter]
    public let carthagePath: Path

    public init(yaml: Yaml?) {
        self.fileName = yaml?.fileName ?? Self.defaultFileName
        let templatePathString = yaml?.templatePath ?? Self.defaultTemplatesPath
        self.templatePath = Path(templatePathString) ?? cwd/templatePathString
        self.generateXcodeProject = yaml?.generateXcodeProject ?? Self.defaultGenerateXcodeProject
        self.generateXcodeWorkspace = yaml?.generateXcodeWorkspace ?? Self.defaultGenerateXcodeWorkspace
        self.generators = yaml?.generators?.somethingOrNil() ?? Generator.allCases
        self.converters = yaml?.converters ?? []
        self.carthagePath = yaml?.carthagePath ?? Self.defaultCarthagePath
    }
}

extension Options {
    // sourcery: AutoInit, AutoMerge
    public struct Yaml: Codable {
        public let fileName: String?
        public let templatePath: String?
        public let generateXcodeProject: Bool?
        public let generateXcodeWorkspace: Bool?
        public let generators: [Generator]?
        public let converters: [Converter]?
        public let carthagePath: Path?

// sourcery:inline:auto:Options.Yaml.AutoInit
        public init(
            fileName: String?,
            templatePath: String?,
            generateXcodeProject: Bool?,
            generateXcodeWorkspace: Bool?,
            generators: [Generator]?,
            converters: [Converter]?,
            carthagePath: Path?
         ) {
            self.fileName = fileName
            self.templatePath = templatePath
            self.generateXcodeProject = generateXcodeProject
            self.generateXcodeWorkspace = generateXcodeWorkspace
            self.generators = generators
            self.converters = converters
            self.carthagePath = carthagePath
        }
// sourcery:end
    }
}
