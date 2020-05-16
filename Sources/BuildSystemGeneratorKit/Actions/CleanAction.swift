import Foundation

public class CleanAction: Action {
    private let cliOptions: Options.CLI
    private let writer: Writer

    public init(_ cliOptions: Options.CLI, _ writer: Writer = Writer()) {
        self.cliOptions = cliOptions
        self.writer = writer
    }

    public func execute() throws {
        writer.shouldWrite = false

        let generateAction = GenerateAction(cliOptions, writer)
        try generateAction.execute()

        for path in writer.writtenFiles {
            try path.delete()
        }
    }
}
