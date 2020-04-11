import Foundation
import Path
import StringCodable

struct TemplateResolver {
    struct Constants {
        public let custom: [String: StringCodable]
        public let firstPartyModules: [FirstPartyModule.Output]
        public let thirdPartyModules: [ThirdPartyModule.Output]
        public let root: Path
        public let templatesFile: Path
    }

    struct Variables {
        let module: FirstPartyModule.Output?
        let path: Path
    }

    let templateEngine: TemplateEngine
    let writer: Writer

    let constants: Constants

    init(writer: Writer, constants: Constants) {
        self.templateEngine = TemplateEngine(constants.templatesFile)
        self.writer = writer
        self.constants = constants
    }

    private func createContext(using variables: Variables) throws -> [String: Any] {
        let context = MainContext(
            custom: constants.custom,
            firstPartyModules: constants.firstPartyModules,
            thirdPartyModules: constants.thirdPartyModules,
            global: Global(
                root: constants.root,
                rootBasename: constants.root.basename(),
                templatesPath: constants.templatesFile,
                parent: variables.path.parent,
                fileName: variables.path.basename()
            ),
            module: variables.module
        )
        return try context.render(variables.path.parent)
    }

    private func _render(template: String, to destinationPath: Path, module: FirstPartyModule.Output?) throws {
        let outputPath: Path = try {
            let provisionalContext = try createContext(using: Variables(module: module, path: cwd))

            let pathString = try templateEngine.render(
                templateContent: destinationPath.string,
                context: provisionalContext
            )
            return Path(pathString)!
        }()

        let rendered: String = try {
            let context = try createContext(using: Variables(module: module, path: outputPath))

            return try templateEngine.render(
                templateContent: template,
                context: context
            )
        }()

        try outputPath.delete()
        try outputPath.parent.mkdir(.p)
        try writer.write(rendered, to: outputPath)
    }

    func render(template: String, relativePath: String, firstPartyModules: [FirstPartyModule.Output], mode: TemplateSpec.Mode) throws {
        switch mode {
        case let .module(filter):
            for module in firstPartyModules where filter.matches(module.name) {
                let destinationPath = module.path/relativePath
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
    }
}
