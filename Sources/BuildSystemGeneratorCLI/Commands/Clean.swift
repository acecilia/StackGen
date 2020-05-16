import Foundation
import SwiftCLI
import BuildSystemGeneratorKit

public class Clean: BaseCommand, Command {
    public let shortDescription: String = "Remove all previously generated files"

    public override func execute() throws {
        try super.execute()

        let options = Options.CLI(
            templates: templates
        )
        try CleanAction(options, env).execute()
    }
}
