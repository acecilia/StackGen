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

        cli.parser.routeBehavior = .searchWithFallback(generateCommand)
    }

    public func execute(arguments: [String]? = nil) {
        let status: Int32
        if let arguments = arguments {
            status = cli.go(with: arguments)
        } else {
            status = cli.go()
        }
        exit(status)
    }
}
