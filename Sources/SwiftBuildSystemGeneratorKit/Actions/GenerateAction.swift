import Foundation
import Path

public class GenerateAction {
    private let commandLineOptions: Options.Yaml

    public init(commandLineOptions: Options.Yaml) {
        self.commandLineOptions = commandLineOptions
    }

    public func execute() throws {
        Reporter.print("Generating configuration files from path: \(Options.rootPath)")

        let workspace = try Workspace.decode(from: Options.rootPath)
        let options = Options(
            yaml: commandLineOptions.merge(with: workspace.options)
        )
        let globals = Globals(yaml: workspace.globals)
        let fileIterator = FileIterator(options)
        let modules = try fileIterator.start()

        Reporter.print("Found modules:")
        modules.forEach {
            let relativePath = $0.path.relative(to: Options.rootPath)
            Reporter.print("\(relativePath)")
        }

        let generators: [GeneratorInterface] = options.generators.map {
            $0.generator(options, globals, modules)
        }

        for generator in generators {
            try generator.generate()
        }

        Reporter.print("Done")
    }
}
