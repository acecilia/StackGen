import Foundation
import SwiftCLI
import StackGenKit

public class MessageGenerator: HelpMessageGenerator {
    private let env: Env

    public init(_ env: Env) {
        self.env = env
    }

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

        let message = env.reporter.formatAsError(description.joined(separator: ". "))
        out.print(message)
    }
}
