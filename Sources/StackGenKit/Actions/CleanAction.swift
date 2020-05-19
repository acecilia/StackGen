import Foundation

/// The action corresponting to the `clean` subcommand
public class CleanAction: Action {
    private let cliOptions: Options.CLI
    private let env: Env

    public init(_ cliOptions: Options.CLI, _ env: Env) {
        self.cliOptions = cliOptions
        self.env = env
    }

    public func execute() throws {
        env.reporter.info(.broom, "cleaning files")

        let env = Env(
            reporter: Reporter(silent: true),
            writer: Writer(shouldWrite: false)
        )
        let generateAction = GenerateAction(cliOptions, env)
        try generateAction.execute()

        for path in env.writer.writtenFiles {
            try path.delete()
        }
    }
}
