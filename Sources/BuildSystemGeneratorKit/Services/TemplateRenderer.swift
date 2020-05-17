import Foundation
import Path
import StringCodable

public class TemplateRenderer {
    public let inputContext: Context.Input
    public let templateEngine: TemplateEngine

    private let env: Env

    public init(_ inputContext: Context.Input, _ env: Env) {
        self.inputContext = inputContext
        self.templateEngine = TemplateEngine(inputContext.templatesFilePath, env)
        self.env = env
    }

    public func render(
        templatePath: Path,
        relativePath: String,
        mode: TemplateSpec.Mode
    ) throws {
        do {
            let template = try String(contentsOf: templatePath)
            let posixPermissions = try FileManager.default
                .attributesOfItem(atPath: templatePath.string)[.posixPermissions]

            switch mode {
            case let .module(filter):
                for module in inputContext.firstPartyModules where filter.matches(module.name) {
                    let destinationPath = module.location.path/relativePath
                    try _render(template: template, to: destinationPath, posixPermissions, module)
                }

            case let .moduleToRoot(filter):
                let destinationPath = env.root/relativePath
                for module in inputContext.firstPartyModules where filter.matches(module.name) {
                    try _render(template: template, to: destinationPath, posixPermissions, module)
                }

            case .root:
                let destinationPath = env.root/relativePath
                try _render(template: template, to: destinationPath, posixPermissions, nil)
            }
        } catch {
            throw CustomError(
                .errorThrownWhileRendering(
                    templatePath: templatePath.relative(to: env.cwd),
                    error: error
                )
            )
        }
    }

    private func _render(
        template: String,
        to outputPath: Path,
        _ posixPermissions: Any?,
        _ module: FirstPartyModule.Output?
    ) throws {
        let outputPath = try resolve(outputPath: outputPath, module: module)

        env.reporter.info(.sparkles, "generating \(outputPath.relative(to: env.cwd))")

        let rendered: String = try {
            let context = try createContext(module: module, outputPath: outputPath)
            return try templateEngine.render(
                templateContent: template,
                context: context
            )
        }()

        try outputPath.parent.mkdir(.p)
        try env.writer.write(rendered, to: outputPath, with: posixPermissions)
    }

    private func createContext(
        module: FirstPartyModule.Output? = nil,
        outputPath: Path
    ) throws -> Context.Middleware {
        let outputContext = Context.Output(
            custom: inputContext.custom,
            firstPartyModules: inputContext.firstPartyModuleNames,
            thirdPartyModules: inputContext.thirdPartyModuleNames,
            global: Global(root: env.root.output, output: outputPath.output),
            module: module
        )

        let middlewareContext = Context.Middleware(
            firstPartyModules: inputContext.firstPartyModules,
            thirdPartyModules: inputContext.thirdPartyModules,
            output: outputContext
        )

        return middlewareContext
    }

    private func resolve(outputPath: Path, module: FirstPartyModule.Output?) throws -> Path {
        let context = try createContext(module: module, outputPath: env.root)

        let pathString = try templateEngine.render(
            templateContent: outputPath.string,
            context: context
        )
        return Path(pathString)!
    }
}
