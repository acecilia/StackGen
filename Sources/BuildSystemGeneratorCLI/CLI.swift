import Foundation
import SwiftCLI
import BuildSystemGeneratorKit
import Path

public class CLI {
    let cli: SwiftCLI.CLI

    public init() {
        // Reset current working directory path
        cwd = Path(Path.cwd)

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
        reporter.start(arguments)
        let status = cli.go(with: arguments)
        reporter.end(status)
        return status
    }
}
