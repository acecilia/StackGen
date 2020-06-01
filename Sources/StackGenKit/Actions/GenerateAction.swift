import Foundation
import Yams
import Path

/// The action corresponting to the `generate` subcommand
public class GenerateAction: Action {
    private let cliOptions: Options.CLI
    private var env: Env

    public init(_ cliOptions: Options.CLI, _ env: Env) {
        self.cliOptions = cliOptions
        self.env = env
    }

    public func execute() throws {
        env.reporter.info(.wrench, "resolving \(StackGenFile.fileName)")

        let stackgenFile: StackGenFile = try {
            let stackgenFile = try StackGenFile.resolve(env)

            if let root = stackgenFile.options.root {
                env.root = Path(root) ?? env.cwd/root
                // If the root is not the cwd, parse again the stackgenFile in
                // order to get the right relative paths
                return try StackGenFile.resolve(env)
            } else {
                return stackgenFile
            }
        }()
        guard stackgenFile.options.version == VERSION else {
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

        env.reporter.info(.wrench, "generating files")

        let inputContext = Context.Input(
            global: stackgenFile.global,
            modules: modules
        )
        let templateRenderer = TemplateRenderer(inputContext, env)

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
    }
}
