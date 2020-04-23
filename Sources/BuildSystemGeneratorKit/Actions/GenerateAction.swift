import Foundation
import Yams
import Path

public class GenerateAction: Action {
    private let cliOptions: Options.Input
    private let writer: Writer

    public init(_ cliOptions: Options.Input, _ writer: Writer = Writer()) {
        self.cliOptions = cliOptions
        self.writer = writer
    }

    public func execute() throws {
        reporter.info("resolving modules")

        let bsgFile: BsgFile
        let bsgFilePath = cwd/BsgFile.fileName
        if bsgFilePath.exists {
            let bsgFileContent = try String(contentsOf: cwd/BsgFile.fileName)
            bsgFile = try YAMLDecoder().decode(from: bsgFileContent, userInfo: [.relativePath: cwd])
        } else {
            bsgFile = try YAMLDecoder().decode(from: "{}", userInfo: [.relativePath: cwd])
        }
        let (firstPartyModules, thirdPartyModules) = try ModuleResolver(bsgFile).resolve()

        let resolvedOptions = try bsgFile.options.resolve(using: cliOptions)
        let templateFilePath = try TemplateSpec.selectTemplate(resolvedOptions.templatesPath)

        // Resolve templates
        let constants = TemplateResolver.Constants(
            custom: bsgFile.custom,
            firstPartyModules: firstPartyModules,
            thirdPartyModules: thirdPartyModules,
            root: cwd,
            templatesFilePath: templateFilePath
        )
        let templateResolver = TemplateResolver(writer: writer, constants: constants)

        // Generate
        let templatesFileContent = try String(contentsOf: templateFilePath)
        let templatesFileRaw: TemplatesFileRaw = try YAMLDecoder().decode(from: templatesFileContent)
        let templatesFile: TemplatesFile = templatesFileRaw.reduce(into: [:]) { (result, pair) in
            let key = Path(pair.key) ?? templateFilePath.parent/pair.key
            result[key] = pair.value
        }

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
