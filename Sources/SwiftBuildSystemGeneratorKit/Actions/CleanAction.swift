import Foundation
import Path

public class CleanAction: Action {
    public init(_ commandLineOptions: Options.Yaml) throws {
        try setCurrent(commandLineOptions)
    }

    public func execute() throws {
        let converters: [ConverterInterface] = Current.options.converters.map {
            $0.build()
        }

        if converters.isEmpty {
            let modules = try FileIterator().start()

            let foundModules = modules.map { $0.path.relative(to: cwd) }.joined(separator: ", ")
            Reporter.info("found modules '\(foundModules)'")

            let generators: [GeneratorInterface] = Current.options.generators.map {
                $0.build(modules)
            }

            for generator in generators {
                try generator.clean()
            }
        } else {
            for converter in converters {
                try converter.clean()
            }
        }
    }
}
