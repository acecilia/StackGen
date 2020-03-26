import Foundation
import BuildSystemGeneratorCLI

let cli = BuildSystemGeneratorCLI()
let status = cli.execute(with: Array(CommandLine.arguments.dropFirst()))
exit(status)
