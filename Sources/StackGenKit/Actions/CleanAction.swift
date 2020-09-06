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

        let writer = Writer(env, dryRun: true)
        let generateEnv: Env = {
            var env = self.env
            env.reporter = Reporter(silent: true)
            return env
        }()
        let generateAction = GenerateAction(cliOptions, generateEnv, writer)
        try generateAction.execute()

        writer.dryRun = false
        try writer.cleanAll()
    }
}
