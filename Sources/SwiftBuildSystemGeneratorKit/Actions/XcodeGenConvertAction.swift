public class XcodeGenConvertAction: Action {
    public init() { }

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
