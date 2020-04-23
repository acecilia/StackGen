import Stencil
import Path
import Foundation
import Path

public class TemplateEngine {
    private let env: Environment
    
    public init(_ templatesFilePath: Path) {
        self.env = Environment(
            loader: FileSystemLoader(paths: [.init(templatesFilePath.parent.relative(to: cwd))]),
            extensions: [CustomExtensions()],
            throwOnUnresolvedVariable: true
        )
    }

    public func render(templateContent: String, context: [String: Any]) throws -> String {
        let fixedTemplateContent = addNewLineDelimiters(templateContent)
        let rendered = try env.renderTemplate(string: fixedTemplateContent, context: context)
        return removeNewLinesDelimiters(rendered)
    }

    /// See: https://github.com/groue/GRMustache/issues/46#issuecomment-19498046
    private func addNewLineDelimiters(_ value: String) -> String {
        return value.replacingOccurrences(of: "\n\n", with: "\n¶\n")
    }

    private func removeNewLinesDelimiters(_ value: String) -> String {
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

class CustomExtensions: Extension {
    override init() {
        super.init()
        self.registerFilter(PathExistsFilter.filterName, filter: PathExistsFilter.run)
    }
}

private class PathExistsFilter {
    static let filterName = "pathExists"

    static func run(_ value: Any?) throws -> Bool {
        guard let string = value as? String else {
            throw CustomError(.filterFailed(filter: filterName, reason: ""))
        }

        let path = try Path(string) ??
            TemplateResolver.latestTemplatePath
                .unwrap(onFailure: "The path for the template required to compute the filter 'pathExists' is not available")
                .parent
                .join(string)

        return path.exists
    }
}
