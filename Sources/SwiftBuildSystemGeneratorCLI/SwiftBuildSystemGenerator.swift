import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit

public class SwiftBuildSystemGeneratorCLI {
    let cli: CLI

    public init(reporter: ReporterInterface = DefaultReporter()) {
        let generateCommand = GenerateCommand(reporter: reporter)

        cli = CLI(
            name: "swiftbuildsystemgenerator",
            description: "Generates build system configurations for swift projects",
            commands: [
                generateCommand,
                CleanCommand(reporter: reporter)
            ]
        )

        cli.helpMessageGenerator = MessageGenerator()
        cli.parser.routeBehavior = .searchWithFallback(generateCommand)
    }

    public func execute(with arguments: [String] = []) -> Int32 {
        return cli.go(with: arguments)
    }
}
