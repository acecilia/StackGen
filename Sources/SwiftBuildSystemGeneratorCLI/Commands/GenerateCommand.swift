import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit
import Path

public class GenerateCommand: Command {
    public static let name: String = "generate"
    public let shortDescription: String = "Generates build system configurations for swift projects"

    let fileName = Key<String>("-f", "--fileName", description: "The file name of the configuration files. Default value is '\(Options.defaultFileName)'")
    let templatesPath = Key<String>("-t", "--templates", description: "The path to the folder containing the templates to use. Default value is '\(Options.defaultTemplatesPath)'")
    let generateXcodeProject = Flag("-x", "--generateXcodeProject", description: "In addition to the build files, also generate the Xcode project and workspace. Default value is '\(Options.defaultGenerateXcodeProject)'")
    let generators = VariadicKey<GeneratorType>("-g", "--generators", description: "A comma separated list of values specifying which generators to execute. Default value is all of them: '\(GeneratorType.allCases.map { $0.rawValue }.joined(separator: " ,"))'")

    let reporter: ReporterInterface
    public init(reporter: ReporterInterface) {
        self.reporter = reporter
    }

    public func execute() throws {
        let options = Options.Yaml(
            fileName: fileName.value,
            templatePath: templatesPath.value,
            generateXcodeProject: generateXcodeProject.value,
            generators: generators.value
        )
        let action = GenerateAction(commandLineOptions: options)
        try action.execute()
    }
}

extension GeneratorType: ConvertibleFromString { }
