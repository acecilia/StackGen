import Foundation

public extension Error {
    /// The final form to be presented to the user when an error happens
    var finalDescription: String {
        return """
        \(localizedDescription)
        \(self)
        """
    }
}
