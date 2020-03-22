import Foundation
import Yams
import Path

public class GenerateAction: Action {
    public init() { }

    public func execute() throws {
        // Resolve modules
        let workspaceFileContent = try String(contentsOf: cwd/"workspace.yml")
        let workspaceFile: WorkspaceFile = try YAMLDecoder().decode(from: workspaceFileContent, userInfo: [.relativePath: cwd])
        let resolver = try Resolver(workspaceFile)
        let mainContext = MainContext(global: workspaceFile.global, modules: resolver.moduleContexts, artifacts: resolver.artifacts)

        // Resolve templates
        for template in workspaceFile.options.templatesPath.ls() where template.isFile {
            let templateFileContent = try String(contentsOf: template)
            let templateFiles: [TemplateFile] = try [YAMLDecoder().decode(from: templateFileContent)]

            for templateFile in templateFiles {
                switch templateFile.context {
                case .module:
                    for module in mainContext.modules {
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
                        for module in mainContext.modules {
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
