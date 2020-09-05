import Foundation
import SwiftCLI
import StackGenKit

public class Lint: BaseCommand, Command {
    public let shortDescription: String = "Lints the \(Constant.stackGenFileName) in the current directory"

    public override func go() throws {
        try LintAction(env).execute()
    }
}
