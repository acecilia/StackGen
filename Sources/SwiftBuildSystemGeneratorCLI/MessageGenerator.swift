import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit

public class MessageGenerator: HelpMessageGenerator {
    public func writeUnrecognizedErrorMessage(for error: Error, to out: WritableStream) {
        let description: Set<String> = [
            // The localizedDescription of the error is useless if it does not conform to LocalizedError:
            // the useful error message can be obtained by using String(describing: error)
            String(describing: error),
            error.localizedDescription
        ]
        writeErrorLine(for: description.joined(separator: ". "), to: out)
    }

    public func writeErrorLine(for errorMessage: String, to out: WritableStream) {
        let message = Reporter.formatAsError(errorMessage)
        out.print(message)
    }
}
