import Foundation
import Path

public class CocoaPodsGenerator: GeneratorInterface {
    private let modules: [Module]

    public init(_ modules: [Module]) {
        self.modules = modules
    }

    public func generate() throws {
        for module in modules {
            let file = OutputPath.podspec
            Reporter.info("generating '\(file.relativePath(for: module))'")
            
            let rendered = try TemplateEngine.shared.render(
                templateName: OutputPath.templateName,
                context: try module.asContext(basePath: cwd)
            )

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

extension CocoaPodsGenerator {
    public enum OutputPath: String, OutputPathInterface {
        public static let templateName = "podspec"

        case podspec

        public func path(for module: Module) -> Path {
            switch self {
            case .podspec:
                return cwd/"\(module.name).podspec"
            }
        }
    }
}

