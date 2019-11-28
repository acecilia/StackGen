import Foundation
import Path

public class GenerateAction: Action {
    public init(_ commandLineOptions: Options.Yaml) throws {
        try setCurrent(commandLineOptions)
    }

    public func execute() throws {
        let fileIterator = FileIterator()
        let modules = try fileIterator.start()

        let foundModules = modules.map { $0.path.relative(to: cwd) }.joined(separator: ", ")
        Reporter.info("found modules '\(foundModules)'")

        let generators: [GeneratorInterface] = Current.options.generators.map {
            $0.build(modules)
        }

        for generator in generators {
            try generator.generate()
        }
    }
}
