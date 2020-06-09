import Foundation
import SwiftCLI
import StackGenKit
import Path

public class CLI {
    public init() { }

    public func execute(with arguments: [String] = []) -> Int32 {
        let env = Env()

        let cli = SwiftCLI.CLI(
            name: "stackGen",
            version: Constant.version,
            description: "Generates build system configurations for swift projects",
            commands: [
                Generate(arguments, env),
                Clean(arguments, env)
            ]
        )

        cli.helpMessageGenerator = MessageGenerator(env)
        cli.parser.routeBehavior = .searchWithFallback(cli.commands.first! as! Command)

        let status = cli.go(with: arguments)
        return status
    }
}
