import Foundation
import Path

public class GenerateAction {
    private let reporter: ReporterInterface
    private let yamlOptions: Options.Yaml

    public init(reporter: ReporterInterface, yamlOptions: Options.Yaml) {
        self.reporter = reporter
        self.yamlOptions = yamlOptions
    }

    public func execute() throws {
        let rootPath = Path(Path.cwd)

        reporter.print("Generating configuration files from path: \(rootPath)")

        let workspace = try Workspace.decode(from: rootPath)
        let options = Options(
            yaml: yamlOptions.merge(with: workspace.options),
            rootPath: rootPath,
            reporter: reporter
        )
        let globals = Globals(yaml: workspace.globals)
        let fileIterator = FileIterator(options)
        let modules = try fileIterator.start()

        reporter.print("Found modules:")
        modules.forEach {
            let relativePath = $0.path.relative(to: rootPath)
            reporter.print("\(relativePath)")
        }

        let generators: [GeneratorInterface] = [
            XcodegenGenerator(options, globals, modules)
        ]

        for generator in generators {
            try generator.generate()
        }

        reporter.print("Done")
    }
}
