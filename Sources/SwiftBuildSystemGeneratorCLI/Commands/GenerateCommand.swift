import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit
import Path

public class GenerateCommand: Command {
    public static let name: String = "generate"
    public let shortDescription: String = "Generates build system configurations for swift projects"

    private let fileName = CommandLineOptions.shared.fileName
    private let templatesPath = CommandLineOptions.shared.templatesPath
    private let generateXcodeProject = CommandLineOptions.shared.generateXcodeProject
    private let generators = CommandLineOptions.shared.generators
    private let carthagePath = CommandLineOptions.shared.carthagePath

    public init() { }

    public func execute() throws {
        let options = Options.Yaml(
            fileName: fileName.value,
            templatePath: templatesPath.value,
            generateXcodeProject: generateXcodeProject.value,
            generators: generators.value,
            converters: nil,
            carthagePath: carthagePath.value
        )
        try GenerateAction(options).execute()
    }
}
