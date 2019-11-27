import Foundation
import Path

public class GenerateAction: Action {
    public init(_ commandLineOptions: Options.Yaml) throws {
        try setCurrent(commandLineOptions)
    }

    public func execute() throws {
        Reporter.print("Generating configuration files from path: \(Current.wd)")

        let fileIterator = FileIterator()
        let modules = try fileIterator.start()

        Reporter.print("Found modules:")
        modules.forEach {
            let relativePath = $0.path.relative(to: Current.wd)
            Reporter.print("\(relativePath)")
        }

        let generators: [GeneratorInterface] = Current.options.generators.map {
            $0.build(modules)
        }

        for generator in generators {
            try generator.generate()
        }

        Reporter.print("Done")
    }
}
