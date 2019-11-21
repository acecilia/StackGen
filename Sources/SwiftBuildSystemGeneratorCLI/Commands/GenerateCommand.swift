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

    let reporter: ReporterInterface
    public init(reporter: ReporterInterface) {
        self.reporter = reporter
    }

    public func execute() throws {
        let options = Options.Yaml(
            fileName: fileName.value,
            templatePath: templatesPath.value,
            generateXcodeProject: generateXcodeProject.value
        )
        let action = GenerateAction(reporter: reporter, yamlOptions: options)
        try action.execute()
    }
}
