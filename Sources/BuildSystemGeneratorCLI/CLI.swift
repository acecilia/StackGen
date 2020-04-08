import Foundation
import SwiftCLI
import BuildSystemGeneratorKit

public class CLI {
    let cli: SwiftCLI.CLI

    public init() {
        cli = SwiftCLI.CLI(
            name: "bsg",
            description: "Generates build system configurations for swift projects",
            commands: [
                Generate(),
                Clean()
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
