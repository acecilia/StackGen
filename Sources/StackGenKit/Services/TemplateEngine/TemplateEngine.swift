import Path
import Foundation
import Path

public protocol TemplateEngineInterface {
    func render(template: TemplateEngine.Template, context: Context.Output) throws -> String
}

public class TemplateEngine: TemplateEngineInterface {
    private let env: Env

    // References to the supported template engines, which are lazily loaded
    private lazy var stencil = Stencil(env)

    public init(_ env: Env) {
        self.env = env
    }

    public func render(template: TemplateEngine.Template, context: Context.Output) throws -> String {
        switch try TemplateType(template) {
        case .stencil:
            return try stencil.render(template: template, context: context)

        case .plainText:
            return try template.content()
        }
    }
}
