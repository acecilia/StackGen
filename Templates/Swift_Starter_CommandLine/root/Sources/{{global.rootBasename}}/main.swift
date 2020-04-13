import Foundation
import {{global.rootBasename}}CLI

let cli = CLI()
let status = cli.execute(with: Array(CommandLine.arguments.dropFirst()))
exit(status)
