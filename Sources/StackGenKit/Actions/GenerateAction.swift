import Foundation
import Yams
import Path

/// The action corresponting to the `generate` subcommand
public class GenerateAction: Action {
    private let cliOptions: Options.CLI
    private var env: Env
    private let writer: WriterGenerateProtocol

    public init(_ cliOptions: Options.CLI, _ env: Env, _ writer: WriterGenerateProtocol) {
        self.cliOptions = cliOptions
        self.env = env
        self.writer = writer
    }

    public func execute() throws {
        env.reporter.info(.wrench, "resolving \(Constant.stackGenFileName)")

        let stackgenFile = try StackGenFile.resolve(&env) ?? StackGenFile()
        guard stackgenFile.options.version == Constant.version else {
            throw StackGenError(.stackgenFileVersionNotMatching(stackgenFile.options.version))
        }

        env.reporter.info(.wrench, "resolving templates file")

        let resolvedOptions = try Options.Resolved(cliOptions, stackgenFile.options)
        let templateSpecs = try TemplatesFileResolver(
            stackgenFile.availableTemplateGroups,
            env
        ).resolve(resolvedOptions.templateGroups)

        env.reporter.info(.wrench, "resolving modules")

        let modules = try ModuleResolver(stackgenFile, env).resolve()

        env.reporter.info(.wrench, "rendering files")

        let inputContext = Context.Input(
            mergeBehaviour: stackgenFile.options.mergeBehaviour,
            global: stackgenFile.global,
            modules: modules
        )
        let templateRenderer = TemplateRenderer(inputContext, env, writer)

        for templateSpec in templateSpecs {
            if templateSpec.path.isFile {
                try templateRenderer.render(
                    templatePath: templateSpec.path,
                    relativePath: templateSpec.path.basename(),
                    mode: templateSpec.mode
                )
            } else if templateSpec.path.isDirectory {
                for templatePath in templateSpec.path.find().type(.file) where templatePath.basename() != ".DS_Store" {
                    try templateRenderer.render(
                        templatePath: templatePath,
                        relativePath: templatePath.relative(to: templateSpec.path),
                        mode: templateSpec.mode
                    )
                }
            }
        }

        env.reporter.info(.wrench, "writing files to disk")

        try writer.cleanAll()
        try writer.writeAll()
    }
}
