import Foundation
import SwiftCLI
import StackGenKit

public class Generate: BaseCommand, Command {
    public let shortDescription: String = "Generates file using the \(Constant.stackGenFileName) in the current directory"

    public override func go() throws {
        let options = Options.CLI(
            templateGroups: templateGroups
        )
        try GenerateAction(options, env, Writer(env)).execute()
    }
}
