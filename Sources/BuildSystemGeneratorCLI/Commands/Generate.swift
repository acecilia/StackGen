import Foundation
import SwiftCLI
import BuildSystemGeneratorKit
import Path

public class Generate: Command {
    public let shortDescription: String = "Generates build system configurations for swift projects"

    @Key("-t", "--templatesFile", description: "The path pointing to the templates file to use")
    var templatesFile: Path?

    public init() { }

    public func execute() throws {
        let options = Options.Input(
            templatesFile: templatesFile
        )
        try GenerateAction(options).execute()
    }
}
