import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit
import Path

public class GenerateCommand: Command {
    public let name: String = "generate"
    public let shortDescription: String = "Generates build system configurations for swift projects"

    let reporter: ReporterInterface
    public init(reporter: ReporterInterface) {
        self.reporter = reporter
    }

    public func execute() throws {
        let rootPath = Path(Path.cwd)

        reporter.print("Generating configuration files from path: \(rootPath)")

        let fileIterator = FileIterator()
        let modules = try fileIterator.start(rootPath)

        reporter.print("Found modules:")
        modules.forEach {
            let relativePath = $0.path.relative(to: rootPath)
            reporter.print("\(relativePath)")
        }

        let generators: [FileGeneratorInterface] = [
            XcodegenGenerator(reporter, modules)
        ]

        for generator in generators {
            try generator.generate()
        }

        reporter.print("Done")
    }
}
