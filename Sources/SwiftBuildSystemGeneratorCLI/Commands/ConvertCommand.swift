import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit

public class ConvertCommand: Command {
    public static let name: String = "convert"
    public let shortDescription: String = "Converts build files into 'module.yml'"

    private let fileName = CommandLineOptions.shared.fileName
    private let converters = CommandLineOptions.shared.converters

    public init() { }

    public func execute() throws {
        let options = Options.Yaml(
            fileName: fileName.value,
            templatePath: nil,
            generateXcodeProject: nil,
            generateXcodeWorkspace: nil,
            generators: nil,
            converters: converters.value,
            carthagePath: nil
        )
        try ConvertAction(options).execute()
    }
}
