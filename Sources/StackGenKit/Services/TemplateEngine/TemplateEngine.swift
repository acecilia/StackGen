import Path
import Foundation
import Path

public protocol TemplateEngineInterface {
    func render(template: TemplateEngine.Template, context: Context.Output) throws -> String
}

public class TemplateEngine: TemplateEngineInterface {
    private let env: Env

    // Supported template engines
    private var stencil: Stencil?
    private var swift: Swift?

    public init(_ env: Env) {
        self.env = env
    }

    public func render(template: TemplateEngine.Template, context: Context.Output) throws -> String {
        switch try TemplateType(template) {
        case .stencil:
            return try stencil.unwrap(fallback: Stencil(env))
                .render(template: template, context: context)

        case .swift:
            return try swift.unwrap(fallback: Swift(env))
                .render(template: template, context: context)

        case .plainText:
            return try template.content()
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
