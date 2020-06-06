import Foundation
import SwiftCLI
import StackGenKit

/// A base class used to share command line options among different commands
public class BaseCommand {
    @Key("-t", "--templateGroups", description: "A list of comma separated values that identify the template groups to use. They can either be: a) template groups already included with stackgen, or b) custom template groups declared in the \(Constant.stackGenFileName)")
    var templateGroups: [String]?

    private let arguments: [String]
    let env: Env

    public init(_ arguments: [String], _ env: Env) {
        self.arguments = arguments
        self.env = env
    }

    public final func execute() throws {
        env.reporter.start(arguments, env.cwd)
        try go()
        env.reporter.end()
    }

    public func go() throws {
        fatalError("You must override this when subclassing")
    }
}
