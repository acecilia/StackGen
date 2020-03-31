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

            func write(basePath: Path, module: FirstPartyModule.Output?) throws {
                if let module = module, templateFile.moduleFilter.wrappedValue.matches(module.name) == false {
                    return
                }

                let basePath = basePath/templateFile.subdir
                let context = try mainContext.render(basePath, for: module)

                let fileName = try templateEngine.render(
                    templateContent: templateFile.name,
                    context: context
                )

                let rendered = try templateEngine.render(
                    templateContent: templateFile.content,
                    context: context
                )

                let outputPath = basePath/fileName
                try outputPath.delete()
                try outputPath.parent.mkdir()
                try writer.write(rendered, to: outputPath)
            }

            switch templateFile.mode {
            case .module:
                for module in mainContext.firstPartyModules {
                    try write(basePath: module.path, module: module)
                }

            case .moduleToRoot:
                for module in mainContext.firstPartyModules {
                    try write(basePath: cwd, module: module)
                }

            case .root:
                try write(basePath: cwd, module: nil)
            }
        }
    }
}
