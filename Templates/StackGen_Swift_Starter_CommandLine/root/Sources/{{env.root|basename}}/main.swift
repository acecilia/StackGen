import Foundation
import {{env.root|basename}}CLI

let cli = CLI()
let status = cli.execute(with: Array(CommandLine.arguments.dropFirst()))
exit(status)
