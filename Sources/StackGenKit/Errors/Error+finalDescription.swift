import Foundation
import Stencil

public extension Error {
    /// The final form to be presented to the user when an error happens
    var finalDescription: String {
        if let self = self as? TemplateSyntaxError {
            return SimpleErrorReporter().renderError(self)
        } else {
            return """
            \(localizedDescription)
            \(self)
            """
        }
    }
}
