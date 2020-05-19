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

        let generateEnv: Env = {
            var env = self.env
            env.reporter = Reporter(silent: true)
            env.writer = Writer(shouldWrite: false)
            return env
        }()

        let generateAction = GenerateAction(cliOptions, generateEnv)
        try generateAction.execute()

        for path in generateEnv.writer.writtenFiles {
            try path.delete()
        }
    }
}
