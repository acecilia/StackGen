import SwiftBuildSystemGeneratorCLI

let cli = SwiftBuildSystemGeneratorCLI()
cli.execute(with: Array(CommandLine.arguments.dropFirst()))
