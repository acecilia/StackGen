import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit
import Path

public class CleanCommand: Command {
    public let name: String = "clean"
    public let shortDescription: String = "Removes all generated build system configurations"

    let reporter: ReporterInterface
    public init(reporter: ReporterInterface) {
        self.reporter = reporter
    }

    public func execute() throws {
        let rootPath = Path.cwd/"Examples"

        reporter.print("Removing existing configuration files from path: \(rootPath)")

        let fileIterator = FileIterator()
        let modules = try fileIterator.start(rootPath)

        reporter.print("Found modules:")
        modules.forEach {
            let relativePath = $0.path.relative(to: rootPath)
            reporter.print("\(relativePath)")
        }
        
        let generators: [FileGeneratorInterface] = [
            XcodegenGenerator(modules)
        ]

        for generator in generators {
            let outputFileName = type(of: generator).outputFileName
            let filesToRemove = rootPath.find().type(.file).filter { $0.basename() == outputFileName }
            for fileToRemove in filesToRemove {
                reporter.print("Removed file: \(fileToRemove.relative(to: rootPath))")
                try fileToRemove.delete()
            }
        }

        reporter.print("Done")
    }
}
