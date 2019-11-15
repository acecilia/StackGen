import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit
import Path

public class GenerateCommand: Command {
    public static let name: String = "generate"
    public let shortDescription: String = "Generates build system configurations for swift projects"

    let templatesPath = Key<String>("-t", "--templates", description: "The path to the folder containing the templates to use")
    let generateXcodeProject = Flag("-x", "--generateXcodeProject", description: "In addition to the build files, also generate the Xcode project and workspace")

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
            templatePath: templatesPath.value,
            generateXcodeProject: generateXcodeProject.value
        )
        let fileIterator = FileIterator(options)
        let modules = try fileIterator.start()

        reporter.print("Found modules:")
        modules.forEach {
            let relativePath = $0.path.relative(to: rootPath)
            reporter.print("\(relativePath)")
        }

        let generators: [FileGeneratorInterface] = [
            XcodegenGenerator(options, modules)
        ]

        for generator in generators {
            try generator.generate()
        }

        reporter.print("Done")
    }
}
