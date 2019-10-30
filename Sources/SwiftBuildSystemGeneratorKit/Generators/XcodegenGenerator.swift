import Stencil
import Path
import XcodeProj
import ProjectSpec
import Shell

public class XcodegenGenerator: FileGeneratorInterface {

    private let reporter: ReporterInterface
    private let modules: [Module]

    public init(_ reporter: ReporterInterface, _ modules: [Module]) {
        self.reporter = reporter
        self.modules = modules
    }

    public func generate() throws {
        for module in modules {
            try generateProjectFile(module)
            try generateXcodeProject(module)
            try generateWorkspace(module)
        }
    }

    public func clean() throws {
        for module in modules {
            let filesToRemove = OutputPath.allCases.map { $0.path(for: module) }
            try filesToRemove.forEach {
                try $0.delete()
            }
            let removedFiles = filesToRemove.map { $0.relative(to: module.path) }.joined(separator: ", ")
            reporter.print("Removed files: \(removedFiles)")
        }
    }

    private func generateProjectFile(_ module: Module) throws {
        reporter.print("Generating: \(OutputPath.projectFile.relativePath(for: module))")

        let environment = Environment(loader: FileSystemLoader(paths: [.init(FileIterator.defaultTemplatePath)]))
        let rendered = try environment.renderTemplate(name: OutputPath.projectFileName, context: try module.asDictionary(basePath: module.path))

        let outputPath = OutputPath.projectFile.path(for: module)
        try outputPath.delete()
        try rendered.write(to: outputPath)
    }

    private func generateXcodeProject(_ module: Module) throws {
        reporter.print("Generating: \(OutputPath.xcodeproj.relativePath(for: module))")

        let result = Shell().capture(
            ["/usr/local/bin/xcodegen"],
            workingDirectoryPath: .init(module.path.string),
            env: nil
        )

        if case let .failure(error) = result {
            let errorMessages = [
                error.description,
                error.processError.description
                ]
                .filter {
                    $0.isEmpty == false
                }
            let errorMessage = errorMessages.joined(separator: ". ")

            reporter.print("The xcode project could not be generated using XcodeGen: you will need to generate it by yourself. Error: \(errorMessage)")
        }
    }

    private func generateWorkspace(_ module: Module) throws {
        reporter.print("Generating: \(OutputPath.xcworkspace.relativePath(for: module))")

        let projectReference = XCWorkspaceDataFileRef(location: .group("\(module.name).xcodeproj"))
        let workspaceData = XCWorkspaceData(children: [.file(projectReference)])
        let workspace = XCWorkspace(data: workspaceData)
        let workspacePath = OutputPath.xcworkspace.path(for: module)
        try workspace.write(path: .init(workspacePath.string), override: true)
    }
}

private enum OutputPath: CaseIterable {
    static let projectFileName = "project.yml"

    case projectFile
    case xcodeproj
    case xcworkspace

    func path(for module: Module) -> Path {
        switch self {
        case .projectFile:
            return module.path/Self.projectFileName

        case .xcodeproj:
            return module.path/"\(module.name).xcodeproj"

        case .xcworkspace:
            return module.path/"\(module.name).xcworkspace"
        }
    }

    func relativePath(for module: Module) -> String {
        return path(for: module).relative(to: module.path)
    }

}
