import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit
import Path

public class GenerateCommand: Command {
    public static let name: String = "generate"
    public let shortDescription: String = "Generates build system configurations for swift projects"

    let fileName = Key<String>("-f", "--fileName", description: "The yml file name to be used")

    let reporter: ReporterInterface
    public init(reporter: ReporterInterface) {
        self.reporter = reporter
    }

    public func execute() throws {
        let rootPath = Path(Path.cwd)

        reporter.print("Generating configuration files from path: \(rootPath)")

        let options = Options(
            rootPath: rootPath,
            reporter: reporter,
            fileName: fileName.value
        )
        let fileIterator = FileIterator(options)
        let modules = try fileIterator.start()

        reporter.print("Found modules:")
        modules.forEach {
            let relativePath = $0.path.relative(to: rootPath)
            reporter.print("\(relativePath)")
        }

        let generators: [GeneratorInterface] = [
            XcodegenGenerator(options, modules)
        ]

        for generator in generators {
            try generator.generate()
        }

        reporter.print("Done")
    }
}
