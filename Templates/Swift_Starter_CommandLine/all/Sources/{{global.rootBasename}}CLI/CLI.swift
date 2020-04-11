import Foundation
import SwiftCLI
import {{global.rootBasename}}Kit

public class CLI {
    let cli: SwiftCLI.CLI

    public init() {
        cli = SwiftCLI.CLI(
            name: "name",
            description: "Some description",
            commands: [
                SomeCommand(),
            ]
        )

        cli.helpMessageGenerator = MessageGenerator()
        cli.parser.routeBehavior = .searchWithFallback(cli.commands.first! as! Command)
    }

    public func execute(with arguments: [String] = []) -> Int32 {
        Reporter.start(arguments)
        let status = cli.go(with: arguments)
        Reporter.end(status)
        return status
    }
}
