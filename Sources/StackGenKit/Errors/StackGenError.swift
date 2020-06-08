import Foundation
import Path

/// The errors thrown by the tool
public struct StackGenError: LocalizedError {
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

extension StackGenError {
    /// The kind of errors that the tool is expecing
    public enum Kind: Equatable {
        // Version
        case stackgenFileVersionNotMatching(_ version: String)

        // Module analysis
        case moduleNotFoundInFilesystem(_ moduleId: String)
        case unknownModule(_ name: String, _ firstParty: [String], _ thirdParty: [String])
        case foundDuplicatedModules(_ modules: [String])
        case foundDuplicatedDependencies(_ dependencies: [String], _ module: String)
        case foundDependencyCycle(_ modules: [String])

        // Dependency lookup
        case multipleModulesWithSameNameFoundAmongDetectedModules(_ moduleName: String, _ detectedModules: [String])

        // Paramenters
        case requiredParameterNotFound(name: String)

        // Templates
        case templateGroupNotFound(identifier: String)
        case errorThrownWhileRendering(templatePath: String, error: String)
        case filterFailed(filter: String, reason: String)

        // Unexpected
        case unexpected(_ description: String)

        // Runtime
        case dictionaryKeyNotFound(_ key: String)

        // Optional checks
        case modulesSorting(_ modules: [String], _ sortedModules: [String])
        case dependenciesSorting(_ module: String, _ dependencyGroup: String, _ dependencies: [String], _ sortedDependencies: [String])
        case transitiveDependencyDuplication(_ module: String, _ dependency: String)

        public var errorDescription: String {
            switch self {
            case let .stackgenFileVersionNotMatching(version):
                return """
                The version of the binary did not match the version specified inside the '\(Constant.stackGenFileName)' file.
                Version of the binary: '\(Constant.version)'.
                Version inside the '\(Constant.stackGenFileName)' file: '\(version)'.
                """

            case .moduleNotFoundInFilesystem(let moduleId):
                return "Module with identifier '\(moduleId)' was not found when looking for it in the filesystem"

            case let .unknownModule(name, firstParty, thirdParty):
                let firstPartyList = firstParty.map { $0 }.joined(separator: ", ")
                let thirdPartyList = thirdParty.map { $0 }.joined(separator: ", ")
                return """
                Module '\(name)' could not be found among the specified modules.
                First party modules: '\(firstPartyList)'
                Third party modules: '\(thirdPartyList)'
                """

            case let .foundDuplicatedModules(modules):
                return "Found multiple modules with the same name. This is not permitted, a module name must be unique. Duplicated modules: '\(modules.joined(separator: ", "))'"

            case let .foundDuplicatedDependencies(dependencies, module):
                return "Found dependencies specified multiple times under the '\(module)' first party module. Dependencies: '\(dependencies.joined(separator: ", "))'"

            case let .foundDependencyCycle(modules):
                return "Found dependency cycle: \(modules.joined(separator: " -> "))"

            case .multipleModulesWithSameNameFoundAmongDetectedModules(let moduleName, let detectedModules):
                return "Multiple modules with the same name ('\(moduleName)') were found among the detected modules: '\(detectedModules)'"

            case let .requiredParameterNotFound(name):
                return "Required parameter not passed as command line argument neither found in the '\(Constant.stackGenFileName)' file. Parameter: '\(name)'"

            case let .templateGroupNotFound(identifier):
                return "Templates group not found for identifier '\(identifier)'"

            case let .errorThrownWhileRendering(templatePath, error):
                return """
                Error thrown while rendering template at path '\(templatePath)'
                \(error)
                """

            case let .filterFailed(filter, reason):
                return "The stencil filter '\(filter)' Failed. Reason: \(reason)"

            case let .unexpected(description):
                return "An unexpected error occurred. \(description)"

            case let .dictionaryKeyNotFound(key):
                return "The key '\(key)' was not found inside the dictionary"

            case let .modulesSorting(modules, sortedModules):
                return """
                The modules sorting is incorrect:
                Current:  \(modules.joined(separator: ", "))
                Expected: \(sortedModules.joined(separator: ", "))
                """

            case let .dependenciesSorting(module, dependencyGroup, dependencies, sortedDependencies):
                return """
                The dependencies sorting for the module '\(module)' and dependencyGroup '\(dependencyGroup)' is incorrect:
                Current:  \(dependencies.joined(separator: ", "))
                Expected: \(sortedDependencies.joined(separator: ", "))
                """

            case let .transitiveDependencyDuplication(module, name):
                return "The module '\(module)' specifies the dependency '\(name)', which is redundant because '\(name)' is already part of the transitive dependencies of '\(module)'"
            }
        }
    }
}
