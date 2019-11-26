public enum Generator: String, CaseIterable, Codable {
    case xcodegen
    case cocoapods

    func build(_ modules: [Module]) -> GeneratorInterface {
        switch self {
        case .xcodegen:
            return XcodegenGenerator(modules)

        case .cocoapods:
            return CocoaPodsGenerator(modules)
        }
    }
}

