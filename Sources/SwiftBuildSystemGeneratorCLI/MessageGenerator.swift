import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit

public class MessageGenerator: HelpMessageGenerator {
    public func writeUnrecognizedErrorMessage(for error: Error, to out: WritableStream) {
        let fileInformation: String?
        if let error = error as? ErrorInterface {
            fileInformation = "Error originated at file \(error.fileName):\(error.line)"
        } else {
            fileInformation = nil
        }

        let errorDescription: String
        if let error = error as? ThirdPartyErrorInterface {
            errorDescription = error.thirdPartyErrorDescription
        } else {
            errorDescription = String(describing: error)
        }

        let description: [String] = [
            // The localizedDescription of the error is useless if it does not conform to LocalizedError:
            // the useful error message can be obtained by using String(describing: error)
            errorDescription,
            fileInformation
            ]
            .compactMap { $0 }

        writeErrorLine(for: description.joined(separator: ". "), to: out)
    }

    public func writeErrorLine(for errorMessage: String, to out: WritableStream) {
        let message = Reporter.formatAsError(errorMessage)
        out.print(message)
    }
}
