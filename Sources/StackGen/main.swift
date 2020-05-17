import Foundation
import StackGenCLI

let cli = CLI()
let status = cli.execute(with: Array(CommandLine.arguments.dropFirst()))
exit(status)
