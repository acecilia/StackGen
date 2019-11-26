import Path
import XcodeProj
import ProjectSpec
import XcodeGenKit

public class XcodegenGenerator: GeneratorInterface {
    private let modules: [Module]

    public init(_ modules: [Module]) {
        self.modules = modules
    }

    public func generate() throws {
        for module in modules {
            try generateProjectFile(module)
            if Current.options.generateXcodeProject {
                try generateXcodeProject(module)
                try generateWorkspace(module)
            }
        }
    }

    public func clean() throws {
        try modules.forEach {
            try OutputPath.cleanAll(for: $0)
        }
    }

    private func generateProjectFile(_ module: Module) throws {
        let file = OutputPath.projectFile
        Reporter.print("Generating: \(file.relativePath(for: module))")

        let rendered = try TemplateEngine.shared.render(
            templateName: OutputPath.projectFileName,
            context: try module.asContext(basePath: module.path)
        )

        let outputPath = file.path(for: module)
        try outputPath.delete()
        try rendered.write(to: outputPath)
    }

    private func generateXcodeProject(_ module: Module) throws {
        Reporter.print("Generating: \(OutputPath.xcodeproj.relativePath(for: module))")

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
        Reporter.print("Generating: \(file.relativePath(for: module))")

        let projectReference = XCWorkspaceDataFileRef(location: .group(module.name + ".xcodeproj"))
        let dependencies: [XCWorkspaceDataElement] = module.mainTarget.dependencies
            .compactMap {
                switch $0 {
                case let .module(dependency):
                    let xcodeProjectPath = (dependency.path/(dependency.name + ".xcodeproj")).relative(to: module.path)
                    return XCWorkspaceDataFileRef(location: .group(xcodeProjectPath))

                case .framework:
                    // Nothing to do
                    return nil
                }

            }
            .map { XCWorkspaceDataElement.file($0) }
        let dependenciesGroup = XCWorkspaceDataGroup(location: .group(""), name: "Dependencies", children: dependencies)

        let workspaceData = XCWorkspaceData(children: [.file(projectReference), .group(dependenciesGroup)])
        let workspace = XCWorkspace(data: workspaceData)
        try workspace.write(path: .init(file.absolutePath(for: module)), override: true)
    }
}

extension XcodegenGenerator {
    public enum OutputPath: String, OutputPathInterface {
        public static let projectFileName = "project.yml"

        case projectFile
        case xcodeproj
        case xcworkspace
        case supportingFiles

        public func path(for module: Module) -> Path {
            switch self {
            case .projectFile:
                return module.path/Self.projectFileName

            case .xcodeproj:
                return module.path/"\(module.name).xcodeproj"

            case .xcworkspace:
                return module.path/"\(module.name).xcworkspace"

            case .supportingFiles:
                return module.path/OutputPath.supportingFiles.rawValue
            }
        }
    }

}
