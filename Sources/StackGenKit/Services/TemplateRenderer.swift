import Foundation
import Path
import StringCodable

/// The service in charge of passing the context to the templates, render them
/// and write them to disk
public class TemplateRenderer {
    private let inputContext: Context.Input
    private let firstPartyModules: [FirstPartyModule.Output]
    private let templateEngine: TemplateEngine

    private let env: Env
    private let writer: WriterAppendProtocol

    public init(_ inputContext: Context.Input, _ env: Env, _ writer: WriterAppendProtocol) {
        self.inputContext = inputContext
        self.firstPartyModules = inputContext.modules.firstParty
        self.templateEngine = TemplateEngine(env)
        self.env = env
        self.writer = writer
    }

    public func render(
        templatePath: Path,
        relativePath: String,
        mode: TemplateSpec.Mode
    ) throws {
        do {
            let template = TemplateEngine.Template(templatePath)
            let posixPermissions = try FileManager.default.attributesOfItem(atPath: templatePath.string)[.posixPermissions]

            switch mode {
            case let .module(filter):
                for module in firstPartyModules where filter.wrappedValue.matches(module.name) {
                    let destinationPath = module.path/relativePath
                    try _render(template: template, to: destinationPath, posixPermissions, module)
                }

            case let .moduleToRoot(filter):
                let destinationPath = env.root/relativePath
                for module in firstPartyModules where filter.wrappedValue.matches(module.name) {
                    try _render(template: template, to: destinationPath, posixPermissions, module)
                }

            case .root:
                let destinationPath = env.root/relativePath
                try _render(template: template, to: destinationPath, posixPermissions, nil)
            }
        } catch {
            throw StackGenError(
                .errorThrownWhileRendering(
                    templatePath: templatePath.relative(to: env.cwd),
                    error: error.finalDescription
                )
            )
        }
    }

    private func _render(
        template: TemplateEngine.Template,
        to outputPath: Path,
        _ posixPermissions: Any?,
        _ module: FirstPartyModule.Output?
    ) throws {
        let outputPath = try resolve(outputPath: outputPath, module: module)

        env.reporter.info(.pageFacingUp, "rendering \(outputPath.relative(to: env.cwd))")

        let content: String = try {
            let context = try createContext(module: module, outputPath: outputPath)
            return try templateEngine.render(
                template: template,
                context: context
            )
        }()

        writer.append(
            writeOperation: .init(
                content: content,
                path: outputPath,
                posixPermissions: posixPermissions,
                mergeBehaviour: inputContext.mergeBehaviour
            )
        )
    }

    private func createContext(
        module: FirstPartyModule.Output? = nil,
        outputPath: Path
    ) throws -> Context.Output {
        let outputContext = Context.Output(
            env: Context.Env(root: env.root, output: outputPath, mergeBehaviour: inputContext.mergeBehaviour),
            global: inputContext.global,
            modules: inputContext.modules,
            module: module
        )

        return outputContext
    }

    private func resolve(outputPath: Path, module: FirstPartyModule.Output?) throws -> Path {
        let context = try createContext(module: module, outputPath: env.root)

        let pathString = try templateEngine.render(
            template: .init(outputPath.string),
            context: context
        )
        return Path.root/pathString
    }
}
