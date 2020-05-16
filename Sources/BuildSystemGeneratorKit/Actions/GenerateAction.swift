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
        env.reporter.info(.wrench, "resolving modules")

        let bsgFile: BsgFile = try {
            let bsgFile = try BsgFile.resolve(env)

            if let topLevel = bsgFile.options.topLevel {
                env.topLevel = Path(topLevel) ?? env.cwd/topLevel
                return try BsgFile.resolve(env)
            } else {
                return bsgFile
            }
        }()

        let resolvedOptions = try Options.Resolved(cliOptions, bsgFile.options)
        let (firstPartyModules, thirdPartyModules) = try ModuleResolver(bsgFile, env).resolve()

        env.reporter.info(.wrench, "resolving templates")

        let templateFilePath = try TemplateResolver2(env).resolveTemplate(resolvedOptions.templates)
        let constants = TemplateResolver.Constants(
            custom: bsgFile.custom,
            firstPartyModules: firstPartyModules,
            thirdPartyModules: thirdPartyModules,
            root: env.topLevel,
            templatesFilePath: templateFilePath
        )
        let templateResolver = TemplateResolver(constants, env)

        let templatesFileContent = try String(contentsOf: templateFilePath)
        let templatesFileRaw: TemplatesFileRaw = try YAMLDecoder().decode(from: templatesFileContent)
        let templatesFile: TemplatesFile = templatesFileRaw.reduce(into: [:]) { (result, pair) in
            let key = Path(pair.key) ?? templateFilePath.parent/pair.key
            result[key] = pair.value
        }

        env.reporter.info(.wrench, "generating files")

        for (path, templateSpec) in templatesFile {
            if path.isFile {
                try templateResolver.render(
                    templatePath: path,
                    relativePath: path.basename(),
                    firstPartyModules: firstPartyModules,
                    mode: templateSpec.mode
                )
            } else if path.isDirectory {
                for templatePath in path.find().type(.file) where templatePath.basename() != ".DS_Store" {
                    try templateResolver.render(
                        templatePath: templatePath,
                        relativePath: templatePath.relative(to: path),
                        firstPartyModules: firstPartyModules,
                        mode: templateSpec.mode
                    )
                }
            }
        }
    }
}
