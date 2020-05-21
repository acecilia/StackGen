import Foundation
import StackGen_Swift_Starter_CommandLineCLI

let cli = CLI()
let status = cli.execute(with: Array(CommandLine.arguments.dropFirst()))
exit(status)
