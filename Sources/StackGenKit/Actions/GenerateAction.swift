import Foundation
import Yams
import Path

public class GenerateAction: Action {
    private let cliOptions: Options.CLI
    private var env: Env

    public init(_ cliOptions: Options.CLI, _ env: Env) {
        self.cliOptions = cliOptions
        self.env = env
    }

    public func execute() throws {
        env.reporter.info(.wrench, "resolving \(StackGenFile.fileName)")

        let stackGenFile: StackGenFile = try {
            let stackGenFile = try StackGenFile.resolve(env)

            if let root = stackGenFile.options.root {
                env.root = Path(root) ?? env.cwd/root
                // If the root is not the cwd, parse again the stackGenFile in
                // order to get the right relative paths
                return try StackGenFile.resolve(env)
            } else {
                return stackGenFile
            }
        }()

        env.reporter.info(.wrench, "resolving templates file")

        let resolvedOptions = try Options.Resolved(cliOptions, stackGenFile.options)
        let (templatesFilePath, templatesFile) = try TemplateResolver(env).resolve(resolvedOptions.templates)

        env.reporter.info(.wrench, "resolving modules")

        let (firstPartyModules, thirdPartyModules) = try ModuleResolver(stackGenFile, env).resolve()

        env.reporter.info(.wrench, "generating files")

        let inputContext = Context.Input(
            custom: stackGenFile.custom,
            firstPartyModules: firstPartyModules,
            thirdPartyModules: thirdPartyModules,
            templatesFilePath: templatesFilePath
        )
        let templateRenderer = TemplateRenderer(inputContext, env)

        for (path, templateSpec) in templatesFile {
            if path.isFile {
                try templateRenderer.render(
                    templatePath: path,
                    relativePath: path.basename(),
                    mode: templateSpec.mode
                )
            } else if path.isDirectory {
                for templatePath in path.find().type(.file) where templatePath.basename() != ".DS_Store" {
                    try templateRenderer.render(
                        templatePath: templatePath,
                        relativePath: templatePath.relative(to: path),
                        mode: templateSpec.mode
                    )
                }
            }
        }
    }
}
