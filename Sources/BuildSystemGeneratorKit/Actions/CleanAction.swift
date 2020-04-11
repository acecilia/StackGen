import Foundation

public class CleanAction: Action {
    public init() { }

    public func execute() throws {
        let writer = Writer()
        writer.shouldWrite = false

        let generateAction = GenerateAction(Options.Input(), writer)
        try generateAction.execute()

        for path in writer.writtenFiles {
            try path.delete()
        }
    }
}
