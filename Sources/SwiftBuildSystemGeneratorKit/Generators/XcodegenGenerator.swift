import Mustache
import Path
import XcodeProj
import ProjectSpec
import XcodeGenKit

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
        let file = OutputPath.projectFile
        reporter.print("Generating: \(file.relativePath(for: module))")

        let templateRepository = TemplateRepository(directoryPath: FileIterator.defaultTemplatePath)
        let template = try templateRepository.template(named: OutputPath.projectFileName)
        let rendered = try template.renderAndTrimNewLines(module.xcodeGenDictionary())

        let outputPath = file.path(for: module)
        try outputPath.delete()
        try rendered.write(to: outputPath)
    }

    private func generateXcodeProject(_ module: Module) throws {
        reporter.print("Generating: \(OutputPath.xcodeproj.relativePath(for: module))")

        // From: https://github.com/yonaskolb/XcodeGen/blob/master/Tests/FixtureTests/FixtureTests.swift
        let project = try Project(path: .init(OutputPath.projectFile.absolutePath(for: module)))
        let generator = ProjectGenerator(project: project)
        let writer = FileWriter(project: project)
        let xcodeProject = try generator.generateXcodeProject()
        try writer.writeXcodeProject(xcodeProject)
        try writer.writePlists()
    }

    private func generateWorkspace(_ module: Module) throws {
        let file = OutputPath.xcworkspace
        reporter.print("Generating: \(file.relativePath(for: module))")

        let projectReference = XCWorkspaceDataFileRef(location: .group(module.name + ".xcodeproj"))
        let dependencies = module.dependencies
            .map {
                let xcodeProjectPath = ($0.path/($0.name + ".xcodeproj")).relative(to: module.path)
                return XCWorkspaceDataFileRef(location: .group(xcodeProjectPath))
            }
            .map { XCWorkspaceDataElement.file($0) }
        let dependenciesGroup = XCWorkspaceDataGroup(location: .group(""), name: "Dependencies", children: dependencies)

        let workspaceData = XCWorkspaceData(children: [.file(projectReference), .group(dependenciesGroup)])
        let workspace = XCWorkspace(data: workspaceData)
        try workspace.write(path: .init(file.absolutePath(for: module)), override: true)
    }
}

private enum OutputPath: CaseIterable {
    static let projectFileName = "project"

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

    func absolutePath(for module: Module) -> String {
        return path(for: module).string
    }
}
