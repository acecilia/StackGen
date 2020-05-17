import Foundation
import SwiftCLI
import StackGenKit

public class Generate: BaseCommand, Command {
    public let shortDescription: String = "Generates file using the \(StackGenFile.fileName) in the current directory"

    public override func go() throws {
        let options = Options.CLI(
            templates: templates
        )
        try GenerateAction(options, env).execute()
    }
}
