import Foundation
import Yams
import Path

public class GenerateAction: Action {
    public init() { }

    public func execute() throws {
        // Resolve modules
        let bsgFileContent = try String(contentsOf: cwd/"\(BsgFile.fileName).yml")
        let bsgFile: BsgFile = try YAMLDecoder().decode(from: bsgFileContent, userInfo: [.relativePath: cwd])
        let resolver = try Resolver(bsgFile)
        let mainContext = MainContext(global: bsgFile.global, firstPartyModules: resolver.firstPartyModules, thirdPartyModules: resolver.thirdPartyModules)

        // Resolve templates
        for template in bsgFile.options.templatesPath.ls() where template.isFile {
            let templateFileContent = try String(contentsOf: template)
            let templateFiles: [TemplateFile] = try [YAMLDecoder().decode(from: templateFileContent)]

            for templateFile in templateFiles {
                switch templateFile.context {
                case .module:
                    for module in mainContext.firstPartyModules {
                        switch templateFile.outputLevel {
                        case .module:
                            let outputPath = module.path/templateFile.subdir
                            let context = try mainContext.asDictionary(outputPath, for: module)
                            try write(templateFile: templateFile, context: context, outputPath: outputPath)

                        case .root:
                            let outputPath = cwd/templateFile.subdir
                            let context = try mainContext.asDictionary(outputPath, for: module)
                            try write(templateFile: templateFile, context: context, outputPath: outputPath)
                        }
                    }

                case .global:
                    switch templateFile.outputLevel {
                    case .module:
                        for module in mainContext.firstPartyModules {
                            let outputPath = module.path/templateFile.subdir
                            let context = try mainContext.asDictionary(outputPath)
                            try write(templateFile: templateFile, context: context, outputPath: outputPath)
                        }

                    case .root:
                        let outputPath = cwd/templateFile.subdir
                        let context = try mainContext.asDictionary(outputPath)
                        try write(templateFile: templateFile, context: context, outputPath: outputPath)
                    }
                }
            }
        }
    }

    private func write(templateFile: TemplateFile, context: [String : Any], outputPath: Path) throws {
        let fileName = try TemplateEngine.shared.render(
            templateContent: templateFile.name,
            context: context
        )

        let rendered = try TemplateEngine.shared.render(
            templateContent: templateFile.content,
            context: context
        )

        let outputPath = outputPath/fileName
        try outputPath.delete()
        try outputPath.parent.mkdir()
        try rendered.write(to: outputPath)
    }
}
