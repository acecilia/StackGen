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
    let generators = VariadicKey<Generator>("-g", "--generators", description: "A comma separated list of values specifying which generators to execute. Default value is all of them: '\(Generator.allCases.map { $0.rawValue }.joined(separator: " ,"))'")
    let carthagePath = Key<String>("-c", "--carthagePath", description: "The path to the folder containing the 'Cartfile'. Default value is the current working directory: \(Options.defaultCarthagePath)")

    public init() { }

    public func execute() throws {
        let options = Options.Yaml(
            fileName: fileName.value,
            templatePath: templatesPath.value,
            generateXcodeProject: generateXcodeProject.value,
            generators: generators.value,
            carthagePath: carthagePath.value.map { Path.cwd/$0 }
        )
        try GenerateAction(options).execute()
    }
}

extension Generator: ConvertibleFromString { }
