public enum GeneratorType: String, CaseIterable, Codable {
    case xcodegen
    case cocoapods

    func generator(_ options: Options, _ globals: Globals, _ modules: [Module]) -> GeneratorInterface {
        switch self {
        case .xcodegen:
            return XcodegenGenerator(options, globals, modules)

        case .cocoapods:
            return CocoaPodsGenerator(options, globals, modules)
        }
    }
}

