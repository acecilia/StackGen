import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit
import Path

public class CleanCommand: Command {
    public static let name: String = "clean"
    public let shortDescription: String = "Removes all generated build system configurations"

    private let fileName = CommandLineOptions.shared.fileName
    private let generators = CommandLineOptions.shared.generators
    private let carthagePath = CommandLineOptions.shared.carthagePath

    public init() { }

    public func execute() throws {
        let options = Options.Yaml(
            fileName: fileName.value,
            templatePath: nil,
            generateXcodeProject: nil,
            generators: generators.value,
            carthagePath: carthagePath.value
        )
        try CleanAction(options).execute()
    }
}

