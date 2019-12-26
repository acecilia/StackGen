// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// MARK: - Options.Yaml AutoMerge
extension Options.Yaml {
    public func merging(_ other: Options.Yaml?) -> Options.Yaml {
        return Options.Yaml(
            fileName: fileName ?? other?.fileName,
            templatePath: templatePath ?? other?.templatePath,
            generateXcodeProject: generateXcodeProject ?? other?.generateXcodeProject,
            generateXcodeWorkspace: generateXcodeWorkspace ?? other?.generateXcodeWorkspace,
            generators: generators ?? other?.generators,
            converters: converters ?? other?.converters,
            carthagePath: carthagePath ?? other?.carthagePath
        )
    }
}
