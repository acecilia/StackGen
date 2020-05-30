import Path
import Foundation
import Path

public protocol TemplateEngineInterface {
    func render(templateContent: String, context: Context.Middleware) throws -> String
}

public class TemplateEngine: TemplateEngineInterface {
    private let env: Env

    // Supported template engines
    private var stencil: Stencil?
    private var swift: Swift?

    public init(_ env: Env) {
        self.env = env
    }

    public func render(templateContent: String, context: Context.Middleware) throws -> String {
        switch TemplateKind(templateContent) {
        case .stencil:
            return try stencil.unwrap(fallback: Stencil(env))
                .render(templateContent: templateContent, context: context)

        case .swift:
            return try swift.unwrap(fallback: Swift(env))
                .render(templateContent: templateContent, context: context)

        case .plainText:
            return templateContent
        }
    }
}

private extension Optional {
    mutating func unwrap(fallback closure: @autoclosure () throws -> Wrapped) throws -> Wrapped {
        if let value = self {
            return value
        } else {
            let value = try closure()
            self = value
            return value
        }
    }
}
