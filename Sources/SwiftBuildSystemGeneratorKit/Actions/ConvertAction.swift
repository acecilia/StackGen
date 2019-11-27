public class ConvertAction: Action {
    public init(_ commandLineOptions: Options.Yaml) throws {
        try setCurrent(commandLineOptions)
    }

    public func execute() throws {
        Reporter.print("Converting build files to 'module.yml' files")

        let converters: [ConverterInterface] = Current.options.converters.map {
            $0.build()
        }

        for converter in converters {
            try converter.convert()
        }

        Reporter.print("Done")
    }
}
