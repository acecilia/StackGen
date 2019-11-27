import Path
import ProjectSpec
import Yams

public class XcodeGenConverter: ConverterInterface {
    public init() { }

    public func convert() throws {
        let xcodeGenFiles = getXcodeGenFiles()

        for xcodeGenFile in xcodeGenFiles {
            Reporter.print("Converting '\(xcodeGenFile)'")

            let project = try Project(path: .init(xcodeGenFile.string))
            guard let mainTarget = project.targets.first, [.framework, .staticFramework].contains(mainTarget.type),
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
            var content = try encoder.encode(
                module,
                userInfo: [.relativePath: xcodeGenFile.parent]
            )
            if content == "{}\n" {
                // The YAMLEncoder adds brackets when there is nothing to encode. They should be removed
                content = ""
            }

            let outputPath = OutputPath.moduleFile.path(for: xcodeGenFile)
            try outputPath.delete()
            try content.write(to: outputPath)
        }
    }

    private func getXcodeGenFiles() -> [Path] {
        return Path.cwd.find().type(.file).filter {
            $0.basename() == XcodegenGenerator.OutputPath.projectFileName
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
            case .framework where dependency.implicit == true:
                let path = try xcodeGenFiles
                    .map { $0.parent }
                    .first { $0.basename() == name }
                    .unwrap(onFailure: "The specified module could not be found. Reference: \(dependency.reference). Name: \(name)")
                dependencies.append(.module(path))

            case .carthage:
                dependencies.append(.framework(dependency.reference))
            case .framework:
                let name = (Path.cwd/dependency.reference).basename(dropExtension: true)
                dependencies.append(.framework(name))
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

    public func clean() throws {
        let xcodeGenFiles = getXcodeGenFiles()
        for xcodeGenFile in xcodeGenFiles {
            try OutputPath.cleanAll(for: xcodeGenFile)
        }
    }
}

extension XcodeGenConverter {
    public enum OutputPath: String, OutputPathInterface {
        public static let moduleFileName = "module.yml"

        case moduleFile

        public func path(for xcodeGenFilePath: Path) -> Path {
            switch self {
            case .moduleFile:
                return xcodeGenFilePath.parent/Self.moduleFileName
            }
        }
    }
}
