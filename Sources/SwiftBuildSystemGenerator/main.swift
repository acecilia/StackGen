import SwiftBuildSystemGeneratorCLI

let cli = SwiftBuildSystemGeneratorCLI()
print(CommandLine.arguments.dropFirst())
cli.execute(with: Array(CommandLine.arguments.dropFirst()))
