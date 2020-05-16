import Foundation
import SwiftCLI
import BuildSystemGeneratorKit

public class Clean: BaseCommand, Command {
    public let shortDescription: String = "Remove all previously generated files"

    public func execute() throws {
        let options = Options.CLI(
            templates: templates
        )
        try CleanAction(options).execute()
    }
}
