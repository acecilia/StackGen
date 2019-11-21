import Foundation
import Path
import Mustache

public class CocoaPodsGenerator: GeneratorInterface {
    private let options: Options
    private let globals: Globals
    private let modules: [Module]

    public init(_ options: Options, _ globals: Globals, _ modules: [Module]) {
        self.options = options
        self.globals = globals
        self.modules = modules
    }

    public func generate() throws {
        for module in modules {
            let file = OutputPath.podspec
            Reporter.print("Generating: \(file.relativePath(for: module))")

            let templateRepository = TemplateRepository(directoryPath: options.templatePath)
            let template = try templateRepository.template(named: OutputPath.templateName)
            let context = try module.asContext(basePath: Options.rootPath, globals: globals)
            let rendered = try template.renderAndTrimNewLines(context)

            let outputPath = file.path(for: module)
            try outputPath.delete()
            try rendered.write(to: outputPath)
        }
    }

    public func clean() throws {
        try modules.forEach {
            try OutputPath.cleanAll(for: $0)
        }
    }
}

private enum OutputPath: String, OutputPathInterface{
    static let templateName = "podspec"

    case podspec

    func path(for module: Module) -> Path {
        switch self {
        case .podspec:
            return Options.rootPath/"\(module.name).podspec"
        }
    }
}
