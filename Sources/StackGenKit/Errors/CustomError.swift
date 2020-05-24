import Foundation
import Path

/// The errors thrown by the tool
public struct CustomError: LocalizedError {
    public let kind: Kind
    public let fileName: String
    public let line: Int

    public init(_ kind: Kind, file: String = #file, line: Int = #line) {
        self.kind = kind
        self.fileName = URL(fileURLWithPath: file).lastPathComponent
        self.line = line
    }

    public var errorDescription: String? {
        """
        \(kind.errorDescription)
        Error originated at file '\(fileName)', line '\(line)'
        """
    }
}

public extension CustomError {
    /// The kind of errors that the tool is expecing
    enum Kind {
        // Version
        case stackgenFileVersionNotMatching(_ version: String)

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
        case templateGroupNotFound(identifier: String)
        case errorThrownWhileRendering(templatePath: String, error: Error)
        case filterFailed(filter: String, reason: String)

        // Unexpected
        case unexpected(_ description: String)
    
        public var errorDescription: String {
            switch self {
            case let .stackgenFileVersionNotMatching(version):
                return """
                The version of the binary did not match the version specified inside the '\(StackGenFile.fileName)' file.
                Version of the binary: '\(VERSION)'.
                Version inside the '\(StackGenFile.fileName)' file: '\(version)'.
                """

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
                return "Required parameter not passed as command line argument neither found in the '\(StackGenFile.fileName)' file. Parameter: '\(name)'"

            case let .templateGroupNotFound(identifier):
                return "Templates group not found for identifier '\(identifier)'"

            case let .errorThrownWhileRendering(templatePath, error):
                return """
                Error thrown while rendering template at path '\(templatePath)'
                \(error.finalDescription)
                """

            case let .filterFailed(filter, reason):
                return "The stencil filter '\(filter)' Failed. Reason: \(reason)"

            case let .unexpected(description):
                return "An unexpected error occurred. \(description)"
            }
        }
    }
}
