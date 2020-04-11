import Foundation
import Yams
import Path

public class GenerateAction: Action {
    private let options: Options.Input
    private let writer: Writer

    public init(_ options: Options.Input, _ writer: Writer = Writer()) {
        self.options = options
        self.writer = writer
    }

    public func execute() throws {
        // Resolve modules
        let bsgFile: BsgFile
        let bsgFilePath = cwd/BsgFile.fileName
        if bsgFilePath.exists {
            let bsgFileContent = try String(contentsOf: cwd/BsgFile.fileName)
            bsgFile = try YAMLDecoder().decode(from: bsgFileContent, userInfo: [.relativePath: cwd])
        } else {
            bsgFile = try YAMLDecoder().decode(from: "{}", userInfo: [.relativePath: cwd])
        }
        let moduleResolver = try ModuleResolver(bsgFile)

        let resolvedOptions = try bsgFile.options.resolve(using: options)

        // Resolve templates
        let constants = TemplateResolver.Constants(
            custom: bsgFile.custom,
            firstPartyModules: moduleResolver.firstPartyModules,
            thirdPartyModules: moduleResolver.thirdPartyModules,
            root: cwd,
            templatesPath: resolvedOptions.templatesPath
        )
        let templateResolver = TemplateResolver(writer: writer, constants: constants)

        // Generate
        for template in resolvedOptions.templatesPath.ls() where template.isFile {
            let templateSpec: TemplateSpec = try YAMLDecoder().decode(from: try String(contentsOf: template))

            if let inlineTemplate = templateSpec.template {
                try templateResolver.render(
                    template: inlineTemplate.content,
                    relativePath: inlineTemplate.outputPath,
                    firstPartyModules: moduleResolver.firstPartyModules,
                    mode: templateSpec.mode
                )
            } else {
                let directoryPath = template.parent/template.basename(dropExtension: true)
                for template in directoryPath.find().type(.file) where !template.basename().hasPrefix(".") {
                    try templateResolver.render(
                        template: try String(contentsOf: template),
                        relativePath: template.relative(to: directoryPath),
                        firstPartyModules: moduleResolver.firstPartyModules,
                        mode: templateSpec.mode
                    )
                }
            }
        }
    }
}
