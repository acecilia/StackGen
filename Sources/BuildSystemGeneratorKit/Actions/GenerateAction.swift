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
            templatesFile: resolvedOptions.templatesFile
        )
        let templateResolver = TemplateResolver(writer: writer, constants: constants)

        // Generate
        let templatesFileContent = try String(contentsOf: resolvedOptions.templatesFile)
        let templatesFileRaw: TemplatesFileRaw = try YAMLDecoder().decode(from: templatesFileContent)
        let templatesFile: TemplatesFile = templatesFileRaw.reduce(into: [:]) { (result, pair) in
            let key = Path(pair.key) ?? resolvedOptions.templatesFile.parent/pair.key
            result[key] = pair.value
        }

        for (path, templateSpec) in templatesFile {
            if path.isFile {
                try templateResolver.render(
                    template: try String(contentsOf: path),
                    relativePath: path.basename(),
                    firstPartyModules: moduleResolver.firstPartyModules,
                    mode: templateSpec.mode
                )
            } else if path.isDirectory {
                for template in path.find().type(.file) where template.basename() != ".DS_Store" {
                    try templateResolver.render(
                        template: try String(contentsOf: template),
                        relativePath: template.relative(to: path),
                        firstPartyModules: moduleResolver.firstPartyModules,
                        mode: templateSpec.mode
                    )
                }
            }
        }
    }
}
