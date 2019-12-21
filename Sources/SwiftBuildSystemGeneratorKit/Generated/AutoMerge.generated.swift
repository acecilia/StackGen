// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



// MARK: - Options.Yaml AutoMerge
extension Options.Yaml {
    public func merge(with rhs: Options.Yaml?) -> Options.Yaml {
        return Options.Yaml(
            fileName: fileName ?? rhs?.fileName,
            templatePath: templatePath ?? rhs?.templatePath,
            generateXcodeProject: generateXcodeProject ?? rhs?.generateXcodeProject,
            generateXcodeWorkspace: generateXcodeWorkspace ?? rhs?.generateXcodeWorkspace,
            generators: generators ?? rhs?.generators,
            converters: converters ?? rhs?.converters,
            carthagePath: carthagePath ?? rhs?.carthagePath
        )
    }
}
