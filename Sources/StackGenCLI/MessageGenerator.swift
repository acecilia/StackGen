import Foundation
import SwiftCLI
import StackGenKit

public class MessageGenerator: HelpMessageGenerator {
    private let env: Env

    public init(_ env: Env) {
        self.env = env
    }

    public func writeUnrecognizedErrorMessage(for error: Error, to out: WritableStream) {
        let message = description(for: error)
        out.print(message)
    }

    public func description(for error: Error) -> String {
        return env.reporter.formatAsError(error.finalDescription)
    }
}
