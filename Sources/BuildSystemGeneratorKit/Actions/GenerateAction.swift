import Foundation
import Yams
import Path

public class GenerateAction: Action {
    private let writer: Writer

    public init(_ writer: Writer = Writer()) {
        self.writer = writer
    }

    public func execute() throws {
        // Resolve modules
        let bsgFileContent = try String(contentsOf: cwd/BsgFile.fileName)
        let bsgFile: BsgFile = try YAMLDecoder().decode(from: bsgFileContent, userInfo: [.relativePath: cwd])
        let moduleResolver = try ModuleResolver(bsgFile)

        // Resolve templates
        let constants = TemplateResolver.Constants(
            custom: bsgFile.custom,
            firstPartyModules: moduleResolver.firstPartyModules,
            thirdPartyModules: moduleResolver.thirdPartyModules,
            rootPath: cwd,
            templatesPath: bsgFile.options.templatesPath
        )
        let templateResolver = TemplateResolver(writer: writer, constants: constants)

        // Generate
        for template in bsgFile.options.templatesPath.ls() where template.isFile {
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
                for template in directoryPath.find().type(.file) {
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
