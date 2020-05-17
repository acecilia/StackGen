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
        env.reporter.info(.wrench, "resolving \(BsgFile.fileName)")

        let bsgFile: BsgFile = try {
            let bsgFile = try BsgFile.resolve(env)

            if let root = bsgFile.options.root {
                env.root = Path(root) ?? env.cwd/root
                // If the root is not the cwd, parse again the bsgFile in
                // order to get the right relative paths
                return try BsgFile.resolve(env)
            } else {
                return bsgFile
            }
        }()

        env.reporter.info(.wrench, "resolving templates file")

        let resolvedOptions = try Options.Resolved(cliOptions, bsgFile.options)
        let (templatesFilePath, templatesFile) = try TemplateResolver(env).resolve(resolvedOptions.templates)

        env.reporter.info(.wrench, "resolving modules")

        let (firstPartyModules, thirdPartyModules) = try ModuleResolver(bsgFile, env).resolve()

        env.reporter.info(.wrench, "generating files")

        let constants = TemplateRenderer.Constants(
            custom: bsgFile.custom,
            firstPartyModules: firstPartyModules,
            thirdPartyModules: thirdPartyModules,
            templatesFilePath: templatesFilePath
        )
        let templateRenderer = TemplateRenderer(constants, env)

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
