import Foundation
import Path
import StringCodable

extension TemplateResolver {
    public struct Constants {
        public let custom: [String: StringCodable]
        public let firstPartyModules: [FirstPartyModule.Output]
        public let thirdPartyModules: [ThirdPartyModule.Output]
        public let root: Path
        public let templatesFilePath: Path
    }
}

public class TemplateResolver {
    public let templateEngine: TemplateEngine
    public let writer: Writer

    public let constants: Constants

    public init(writer: Writer, constants: Constants) {
        self.writer = writer
        self.constants = constants
        self.templateEngine = TemplateEngine(constants.templatesFilePath)
    }

    public func render(templatePath: Path, relativePath: String, firstPartyModules: [FirstPartyModule.Output], mode: TemplateSpec.Mode) throws {
        do {
            let template = try String(contentsOf: templatePath)

            switch mode {
            case let .module(filter):
                for module in firstPartyModules where filter.matches(module.name) {
                    let destinationPath = module.location.path/relativePath
                    try _render(template: template, to: destinationPath, module: module)
                }

            case let .moduleToRoot(filter):
                let destinationPath = cwd/relativePath
                for module in firstPartyModules where filter.matches(module.name) {
                    try _render(template: template, to: destinationPath, module: module)
                }

            case .root:
                let destinationPath = cwd/relativePath
                try _render(template: template, to: destinationPath, module: nil)
            }
        } catch {
            throw CustomError(.errorThrownWhileRendering(templatePath: templatePath, error: error))
        }
    }

    private func _render(template: String, to outputPath: Path, module: FirstPartyModule.Output?) throws {
        let outputPath = try resolve(outputPath: outputPath, module: module)

        reporter.info("generating \(outputPath.relative(to: cwd))")

        let rendered: String = try {
            let context = try createContext(module: module, outputPath: outputPath)

            return try templateEngine.render(
                templateContent: template,
                context: context
            )
        }()

        try outputPath.delete()
        try outputPath.parent.mkdir(.p)
        try writer.write(rendered, to: outputPath)
    }

    private func createContext(module: FirstPartyModule.Output? = nil, outputPath: Path) throws -> MainContext {
        let context = MainContext(
            custom: constants.custom,
            firstPartyModules: constants.firstPartyModules,
            thirdPartyModules: constants.thirdPartyModules,
            global: Global(
                root: constants.root.output,
                output: outputPath.output
            ),
            module: module
        )

        return context
    }

    private func resolve(outputPath: Path, module: FirstPartyModule.Output?) throws -> Path {
        let context = try createContext(module: module, outputPath: outputPath)

        let pathString = try templateEngine.render(
            templateContent: outputPath.string,
            context: context
        )
        return Path(pathString)!
    }
}
