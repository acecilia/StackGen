import Foundation
import SwiftCLI
import BuildSystemGeneratorKit
import Path

public class Generate: Command {
    public let shortDescription: String = "Generates build system configurations for swift projects"

    @Key("-t", "--templatesPath", description: "The path pointing to the folder that contains the '\(TemplateSpec.fileName)' file")
    var templatesPath: String?

    public init() { }

    public func execute() throws {
        let options = Options.Input(
            templatesPath: templatesPath
        )
        try GenerateAction(options).execute()
    }
}
