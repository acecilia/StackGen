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
        // Version
        case versionCouldNotBeFoundForModule(_ moduleName: String)
        case multipleVersionsFoundForModule(_ moduleName: String, _ path: [Line])

        // Module filesystem lookup
        case moduleNotFoundInFilesystem(_ moduleName: String)
        case multipleModulesWithTheSameNameFoundInFilesystem(_ moduleName: String, _ paths: [Path])

        // Dependency lookup
        case multipleModulesWithSameNameFoundAmongDetectedModules(_ moduleName: String, _ detectedModules: [String])
        
        public var description: String {
            switch self {
            case .versionCouldNotBeFoundForModule(let moduleName):
                return "A version for module '\(moduleName)' could not be found. Make sure the version resolvers specified in the 'workspace.yml' file are correct"

            case .multipleVersionsFoundForModule(let moduleName, let versionSpecs):
                return "Multiple versions found for module '\(moduleName)': '\(versionSpecs)'. Make sure the version resolvers specified in the 'workspace.yml' file are correct"

            case .moduleNotFoundInFilesystem(let moduleName):
                return "Module '\(moduleName)' was not found when looking for it in the filesystem"

            case .multipleModulesWithTheSameNameFoundInFilesystem(let moduleName, let paths):
                return "Multiple filesystem paths were found for module '\(moduleName)': '\(paths)'"

            case .multipleModulesWithSameNameFoundAmongDetectedModules(let moduleName, let detectedModules):
                return "Multiple modules with the same name ('\(moduleName)') were found among the detected modules: '\(detectedModules)'"
            }
        }
    }
}
