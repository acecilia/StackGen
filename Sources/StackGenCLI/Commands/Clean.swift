import Foundation
import SwiftCLI
import StackGenKit

public class Clean: BaseCommand, Command {
    public let shortDescription: String = "Remove all previously generated files"

    public override func go() throws {
        let options = Options.CLI(
            templateGroups: templateGroups
        )
        try CleanAction(options, env).execute()
    }
}
