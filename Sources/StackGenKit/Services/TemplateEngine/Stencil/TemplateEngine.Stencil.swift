import Foundation
import Stencil

extension TemplateEngine {
    /// A wrapper to render stencil templates
    public class Stencil: TemplateEngineInterface {
        private let environment: Environment
        private let extensions = Extensions()

        public init(_ env: Env) {
            self.environment = Environment(
                loader: FileSystemLoader(paths: [.init()]),
                extensions: [extensions],
                throwOnUnresolvedVariable: true
            )
        }

        public func render(templateContent: String, context: Context.Output) throws -> String {
            extensions.set(context)
            let encodedContext = try context.asDictionary(context.env.output.path.parent)
            let fixedTemplateContent = addNewLineDelimiters(templateContent)
            let rendered = try environment.renderTemplate(string: fixedTemplateContent, context: encodedContext)
            return removeNewLinesDelimiters(rendered)
        }

        /// See: https://github.com/groue/GRMustache/issues/46#issuecomment-19498046
        private func addNewLineDelimiters(_ value: String) -> String {
            return value.replacingOccurrences(of: "\n\n", with: "\n¶\n")
        }

        private func removeNewLinesDelimiters(_ value: String) -> String {
            return value
                .replacingOccurrences(of: "\n( *\n)+", with: "\n", options: .regularExpression)
                .replacingOccurrences(of: "^\n+", with: "", options: .regularExpression)
                .replacingOccurrences(of: "¶\n", with: "\n")
        }
    }
}
