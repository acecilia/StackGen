import Foundation
import Path
import ProjectSpec
import Yams

public class XcodeGenConvertAction {
    public init() { }

    public func execute() throws {
        Reporter.print("Converting XcodeGen 'project.yml' files to 'module.yml' files")

        let xcodeGenFiles = Path.cwd.find().type(.file).filter {
            $0.basename() == XcodegenGenerator.OutputPath.projectFileName
        }

        for xcodeGenFile in xcodeGenFiles {
            Reporter.print("Converting '\(xcodeGenFile)'")

            let project = try Project(path: .init(xcodeGenFile.string))
            guard let mainTarget = project.targets.first, mainTarget.type == .framework,
                let testTarget = project.targets[safe: 1], testTarget.type == .unitTestBundle else {
                continue
            }

            let dependencies = try getDependencies(for: mainTarget, using: xcodeGenFiles)
            let testDependencies = try getDependencies(for: testTarget, using: xcodeGenFiles)

            let module = Module.Yaml(
                version: nil,
                dependencies: dependencies,
                testDependencies: testDependencies
            )

            let encoder = YAMLEncoder()
            let content = try encoder.encode(
                module,
                userInfo: [.relativePath: OutputPath.modulePath.path(for: xcodeGenFile)]
            )

            let outputPath = OutputPath.moduleFile.path(for: xcodeGenFile)
            try outputPath.delete()
            try content.write(to: outputPath)
        }
    }

    private func getDependencies(
        for target: ProjectSpec.Target,
        using xcodeGenFiles: [Path]
    ) throws -> [Dependency.Yaml] {
        var dependencies: [Dependency.Yaml] = []

        for dependency in target.dependencies {
            let name = getName(for: dependency)

            switch dependency.type {
            case .framework:
                let path = try xcodeGenFiles
                    .map { OutputPath.modulePath.path(for: $0) }
                    .first { $0.basename() == name }
                    .unwrap(onFailure: "The specified module could not be found. Reference: \(dependency.reference). Name: \(name)")
                dependencies.append(.module(path))

            case .carthage:
                dependencies.append(.framework(dependency.reference))
            case .package, .sdk, .target:
                // Nothing to do: will be handled in the templates
                continue
            }
        }

        return dependencies
    }

    private func getName(for dependency: ProjectSpec.Dependency) -> String {
        return dependency.reference.replacingOccurrences(of: ".framework", with: "")
    }
}

extension XcodeGenConvertAction {
    public enum OutputPath: String {
        public static let moduleFileName = "module.yml"

        case modulePath
        case moduleFile

        public func path(for xcodeGenFilePath: Path) -> Path {
            switch self {
            case .modulePath:
                return xcodeGenFilePath.parent

            case .moduleFile:
                return Self.modulePath.path(for: xcodeGenFilePath)/Self.moduleFileName
            }
        }
    }
}
