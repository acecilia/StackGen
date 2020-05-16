import Foundation

public class CleanAction: Action {
    private let cliOptions: Options.CLI
    private let env: Env

    public init(_ cliOptions: Options.CLI, _ env: Env) {
        self.cliOptions = cliOptions
        self.env = env
    }

    public func execute() throws {
        let writer = Writer()
        writer.shouldWrite = false

        env.reporter.info(.broom, "cleaning files")

        let generateAction = GenerateAction(cliOptions, env)
        try generateAction.execute()

        for path in writer.writtenFiles {
            try path.delete()
        }
    }
}
