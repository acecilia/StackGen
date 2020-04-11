import Foundation
import SwiftCLI
import Swift_Starter_CommandLineKit

public class MessageGenerator: HelpMessageGenerator {
    public func writeUnrecognizedErrorMessage(for error: Error, to out: WritableStream) {
        // The localizedDescription of the error is useless if it does not conform to LocalizedError:
        // the useful error message can be obtained by using String(describing: error)
        let errorDescription = (error as? LocalizedError)?.errorDescription ?? String(describing: error)
        writeErrorLine(for: errorDescription, to: out)
    }

    public func writeErrorLine(for errorMessage: String, to out: WritableStream) {
        let message = Reporter.formatAsError(errorMessage)
        out.print(message)
    }
}
