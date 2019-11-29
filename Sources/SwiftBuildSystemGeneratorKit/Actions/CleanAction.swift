import Foundation
import Path

public class CleanAction: Action {
    public init(_ commandLineOptions: Options.Yaml) throws {
        try setCurrent(commandLineOptions)
    }

    public func execute() throws {
        let modules = try FileIterator().start()
        
        let generators: [GeneratorInterface] = Current.options.generators.map {
            $0.build(modules)
        }

        for generator in generators {
            try generator.clean()
        }
    }
}
