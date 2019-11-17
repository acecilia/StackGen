import Foundation
import SwiftBuildSystemGeneratorCLI

let cli = SwiftBuildSystemGeneratorCLI()
let status = cli.execute(with: Array(CommandLine.arguments.dropFirst()))
exit(status)
