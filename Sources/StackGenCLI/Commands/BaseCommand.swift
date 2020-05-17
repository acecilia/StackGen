import Foundation
import SwiftCLI
import StackGenKit

/// A base class used to share command line options among different commands
public class BaseCommand {
    @Key("-t", "--templates", description: "It can either be: a) an identifier of the templates to use, if they are part of the included templates, or b) the path pointing to the template file to use")
    var templates: String?

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
