import Foundation
import SwiftCLI
import BuildSystemGeneratorKit

public class MessageGenerator: HelpMessageGenerator {
    public func writeUnrecognizedErrorMessage(for error: Error, to out: WritableStream) {
        let fileInformation: String?
        if let error = error as? ErrorInterface {
            fileInformation = "Error originated at file \(error.fileName):\(error.line)"
        } else {
            fileInformation = nil
        }

        // The localizedDescription of the error is useless if it does not conform to LocalizedError:
        // the useful error message can be obtained by using String(describing: error)
        let errorDescription = (error as? LocalizedError)?.errorDescription ?? String(describing: error)
        let description: [String] = [
            errorDescription,
            fileInformation
            ]
            .compactMap { $0 }

        writeErrorLine(for: description.joined(separator: ". "), to: out)
    }

    public func writeErrorLine(for errorMessage: String, to out: WritableStream) {
        let message = reporter.formatAsError(errorMessage)
        out.print(message)
    }
}
