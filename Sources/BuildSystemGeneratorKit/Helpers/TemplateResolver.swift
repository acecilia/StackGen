import Foundation
import Path
import StringCodable
import Compose

extension TemplateResolver {
    public struct Constants1 {
        @CacheEncoding public var custom: [String: StringCodable]
        @CacheEncoding public var firstPartyModules: [FirstPartyModule.Output]
        @CacheEncoding public var thirdPartyModules: [ThirdPartyModule.Output]

        public init(
            custom: [String: StringCodable],
            firstPartyModules: [FirstPartyModule.Output],
            thirdPartyModules: [ThirdPartyModule.Output]
        ) {
            self._custom = CacheEncoding(custom)
            self._firstPartyModules = CacheEncoding(firstPartyModules)
            self._thirdPartyModules = CacheEncoding(thirdPartyModules)
        }
    }

    public struct Constants2 {
        public let root: Path
        public let templatesFile: Path
    }

    public typealias Constants = Compose<Constants1, Constants2>

    public struct Variables {
        public let module: FirstPartyModule.Output?
        public let path: Path
    }
}

public class TemplateResolver {
    public let templateEngine: TemplateEngine
    public let writer: Writer

    public let constants: Constants

    public init(writer: Writer, constants: Constants) {
        self.writer = writer
        self.constants = constants
        self.templateEngine = TemplateEngine(constants.templatesFile)
    }

    private func createContext(using variables: Variables) throws -> [String: Any] {
        let context = MainContext(
            custom: constants.$custom,
            firstPartyModules: constants.$firstPartyModules,
            thirdPartyModules: constants.$thirdPartyModules,
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

    public func render(template: String, relativePath: String, firstPartyModules: [FirstPartyModule.Output], mode: TemplateSpec.Mode) throws {
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
