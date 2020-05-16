import Foundation
import Yams
import Path

public class GenerateAction: Action {
    private let cliOptions: Options.CLI
    private let writer: Writer

    public init(_ cliOptions: Options.CLI, _ writer: Writer = Writer()) {
        self.cliOptions = cliOptions
        self.writer = writer
    }

    public func execute() throws {
        reporter.info(.wrench, "resolving modules")

        let bsgFile = try BsgFile.resolve()
        let resolvedOptions = try Options.Resolved.resolve(cliOptions, bsgFile.options)
        let (firstPartyModules, thirdPartyModules) = try ModuleResolver(bsgFile).resolve()

        reporter.info(.wrench, "resolving templates")

        let templateFilePath = try TemplateSpec.resolveTemplate(resolvedOptions.templates)
        let constants = TemplateResolver.Constants(
            custom: bsgFile.custom,
            firstPartyModules: firstPartyModules,
            thirdPartyModules: thirdPartyModules,
            root: cwd,
            templatesFilePath: templateFilePath
        )
        let templateResolver = TemplateResolver(writer: writer, constants: constants)

        let templatesFileContent = try String(contentsOf: templateFilePath)
        let templatesFileRaw: TemplatesFileRaw = try YAMLDecoder().decode(from: templatesFileContent)
        let templatesFile: TemplatesFile = templatesFileRaw.reduce(into: [:]) { (result, pair) in
            let key = Path(pair.key) ?? templateFilePath.parent/pair.key
            result[key] = pair.value
        }

        reporter.info(.wrench, "generating files")
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
