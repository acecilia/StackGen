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

        let templateEngine = TemplateEngine(bsgFile.options.templatesPath)

        // Resolve templates
        for template in bsgFile.options.templatesPath.ls() where template.isFile {
            let templateFileContent = try String(contentsOf: template)
            let templateFile: TemplateFile = try YAMLDecoder().decode(from: templateFileContent)

            let mainContext = MainContext(
                global: Global(rootPath: cwd, templatesPath: bsgFile.options.templatesPath, fileName: templateFile.name),
                custom: bsgFile.custom,
                firstPartyModules: resolver.firstPartyModules,
                thirdPartyModules: resolver.thirdPartyModules
            )

            switch templateFile.mode {
            case .module:
                for module in mainContext.firstPartyModules {
                    try templateEngine.write(templateFile, mainContext: mainContext, basePath: module.path, module: module)
                }

            case .moduleToRoot:
                for module in mainContext.firstPartyModules {
                    try templateEngine.write(templateFile, mainContext: mainContext, basePath: cwd, module: module)
                }

            case .root:
                try templateEngine.write(templateFile, mainContext: mainContext, basePath: cwd, module: nil)
            }
        }
    }
}

private extension TemplateEngine {
    func write(_ templateFile: TemplateFile, mainContext: MainContext, basePath: Path, module: FirstPartyModule.Output?) throws {
        let basePath = basePath/templateFile.subdir
        let context = try mainContext.render(basePath, for: module)

        let fileName = try self.render(
            templateContent: templateFile.name,
            context: context
        )

        let rendered = try self.render(
            templateContent: templateFile.content,
            context: context
        )

        let outputPath = basePath/fileName
        try outputPath.delete()
        try outputPath.parent.mkdir()
        try rendered.write(to: outputPath)
    }
}
