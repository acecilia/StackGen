import Foundation
import SwiftCLI
import BuildSystemGeneratorKit

public class BuildSystemGeneratorCLI {
    let cli: CLI

    public init() {
        cli = CLI(
            name: "BuildSystemgenerator",
            description: "Generates build system configurations for swift projects",
            commands: [
                GenerateCommand(),
                CleanCommand()
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
