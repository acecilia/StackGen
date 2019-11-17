import Mustache

extension Template {
    /// See: https://github.com/groue/GRMustache/issues/46#issuecomment-19498046
    public func renderAndTrimNewLines(_ value: Any) throws -> String {
        return try render(value)
            .replacingOccurrences(of: "\n( *\n)+", with: "\n", options: .regularExpression)
            .replacingOccurrences(of: "\n¶", with: "\n")
            .replacingOccurrences(of: "¶", with: "\n")
    }
}
