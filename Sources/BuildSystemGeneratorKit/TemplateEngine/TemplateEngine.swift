import Stencil
import Path
import Foundation

class TemplateEngine {
    static let shared = TemplateEngine()
    
    private init() { }

    func render(templateContent: String, context: [String: Any]) throws -> String {
        let rendered = try Environment(throwOnUnresolvedVariable: true).renderTemplate(string: templateContent, context: context)
        return trimNewLines(rendered)
    }

    /// See: https://github.com/groue/GRMustache/issues/46#issuecomment-19498046
    private func trimNewLines(_ value: String) -> String {
        return value
            .replacingOccurrences(of: "\n( *\n)+", with: "\n", options: .regularExpression)
            .replacingOccurrences(of: "\n¶", with: "\n")
    }
}

extension Stencil.TemplateSyntaxError: LocalizedError {
    public var errorDescription: String? {
        let reporter = SimpleErrorReporter()
        return """
        Template syntax error.
        \(reporter.renderError(self))
        """
    }
}
