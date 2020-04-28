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
        case moduleCouldNotBeFoundInSources(_ moduleName: String, _ sources: [Path])
        case versionCouldNotBeFoundForModule(_ moduleName: String, _ line: Line)
        case multipleVersionsFoundForModule(_ moduleName: String, _ source: [Line])

        // Module filesystem lookup
        case moduleNotFoundInFilesystem(_ moduleId: String)
        case multipleModulesWithTheSameIdFoundInFilesystem(_ moduleId: String, _ paths: [Path])

        // Dependency lookup
        case multipleModulesWithSameNameFoundAmongDetectedModules(_ moduleName: String, _ detectedModules: [String])

        // Paramenters
        case requiredParameterNotFound(name: String)

        // Templates
        case templateNotFound(relativePath: String)
        case errorThrownWhileRendering(templatePath: Path, error: Error)
        case filterFailed(filter: String, reason: String)
    
        public var description: String {
            switch self {
            case .moduleCouldNotBeFoundInSources(let moduleName, let sources):
                let sourcesPaths = sources.map { $0.relative(to: cwd) }.joined(separator: ", ")
                return "The module '\(moduleName)' could not be found among the sources: \(sourcesPaths)"

            case .versionCouldNotBeFoundForModule(let moduleName, let line):
                return "A version for module '\(moduleName)' could not be found in \(line.source):\(line.index): '\(line.content)'"

            case .multipleVersionsFoundForModule(let moduleName, let versionSpecs):
                return "Multiple versions found for module '\(moduleName)': '\(versionSpecs)'. Make sure the version resolvers specified in the '\(BsgFile.fileName)' file are correct"

            case .moduleNotFoundInFilesystem(let moduleId):
                return "Module with identifier '\(moduleId)' was not found when looking for it in the filesystem"

            case .multipleModulesWithTheSameIdFoundInFilesystem(let moduleId, let paths):
                return "Multiple filesystem paths were found for module identifier '\(moduleId)': '\(paths)'"

            case .multipleModulesWithSameNameFoundAmongDetectedModules(let moduleName, let detectedModules):
                return "Multiple modules with the same name ('\(moduleName)') were found among the detected modules: '\(detectedModules)'"

            case let .requiredParameterNotFound(name):
                return "Required parameter not passed as command line argument neither found in the '\(BsgFile.fileName)' file. Parameter: '\(name)'"

            case let .templateNotFound(relativePath):
                return "Templates folder not found for path '\(relativePath)'"

            case let .errorThrownWhileRendering(templatePath, error):
                return """
                \(error.localizedDescription)
                Error thrown while rendering template at path '\(templatePath.relative(to: cwd))'
                """

            case let .filterFailed(filter, reason):
                return "The stencil filter '\(filter)' Failed. Reason: \(reason)"
            }
        }
    }
}
