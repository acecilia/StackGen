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
        // Module analysis
        case moduleNotFoundInFilesystem(_ moduleId: String)
        case unknownModule(_ name: String, _ firstParty: [FirstPartyModule.Input], _ thirdParty: [ThirdPartyModule.Output])
        case foundDuplicatedModules(_ modules: [String])
        case foundDuplicatedDependencies(_ dependencies: [String], _ module: String)

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
            case .moduleNotFoundInFilesystem(let moduleId):
                return "Module with identifier '\(moduleId)' was not found when looking for it in the filesystem"

            case let .unknownModule(name, firstParty, thirdParty):
                let firstPartyList = firstParty.map { $0.name }.joined(separator: ", ")
                let thirdPartyList = thirdParty.map { $0.name }.joined(separator: ", ")
                return """
                Module '\(name)' could not be found among the first or third party specified modules.
                First party modules: '\(firstPartyList)'
                Third party modules: '\(thirdPartyList)'
                """

            case let .foundDuplicatedModules(modules):
                return "Found multiple modules with the same name. This is not permitted, a module name must be unique. Duplicated modules: '\(modules.joined(separator: ", "))'"

            case let .foundDuplicatedDependencies(dependencies, module):
                return "Found dependencies specified multiple times under the '\(module)' first party module. Dependencies: '\(dependencies.joined(separator: ", "))'"

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
