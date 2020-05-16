import Foundation
import SwiftCLI
import BuildSystemGeneratorKit

public class Generate: BaseCommand, Command {
    public let shortDescription: String = "Generates file using the \(BsgFile.fileName) in the current directory"

    public override func go() throws {
        let options = Options.CLI(
            templates: templates
        )
        try GenerateAction(options, env).execute()
    }
}
