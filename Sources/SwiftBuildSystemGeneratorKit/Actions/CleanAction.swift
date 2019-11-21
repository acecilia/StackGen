import Foundation
import Path

public class CleanAction {
    let reporter: ReporterInterface
    public init(reporter: ReporterInterface) {
        self.reporter = reporter
    }

    public func execute() throws {
        let rootPath = Path(Path.cwd)

        reporter.print("Removing existing configuration files from path: \(rootPath)")

        let workspace = try Workspace.decode(from: rootPath)

        let options = Options(yaml: workspace.options, rootPath: rootPath, reporter: reporter)
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
            try generator.clean()
        }

        reporter.print("Done")
    }
}
