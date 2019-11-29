import Foundation
import Path

public struct CustomError: Error, ErrorInterface {
    public let kind: Kind
    public let fileName: String
    public let line: Int
    public var description: String { kind.description }

    public init(_ kind: Kind, file: String = #file, line: Int = #line) {
        self.kind = kind
        self.fileName = (cwd/file).basename(dropExtension: false)
        self.line = line
    }
}

public extension CustomError {
    enum Kind: CustomStringConvertible {
        case multipleModulesWithSameName(modules: [String])
        case carthageFrameworkNotFound(name: String)
        case dependencyNotFoundAmongDetectedModules(moduleName: String, dependencyName: String, detectedModules: [String])

        public var description: String {
            switch self {
            case let .multipleModulesWithSameName(modules):
                let modulesList = modules.joined(separator: ", ")
                return "found multiple modules with the same name. Modules: '\(modulesList)'"
            case let .carthageFrameworkNotFound(name):
                return "framework '\(name)' could not be found under the Carthage build folder"
            case let .dependencyNotFoundAmongDetectedModules(moduleName, dependencyName, detectedModules):
                let modulesList = detectedModules.joined(separator: ", ")
                return "module '\(moduleName)' specifies the dependency '\(dependencyName)', but such dependency could not be found among the considered modules: '\(modulesList)'"
            }
        }
    }
}
