import Foundation
import SwiftCLI
import BuildSystemGeneratorKit
import Path

public class Generate: BaseCommand, Command {
    public let shortDescription: String = "Generates file using the \(BsgFile.fileName) in the current directory"

    public func execute() throws {
        let options = Options.CLI(
            templates: templates
        )
        try GenerateAction(options).execute()
    }
}
