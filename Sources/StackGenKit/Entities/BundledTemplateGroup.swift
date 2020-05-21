import Foundation
import Path

/// The template groups bundled with the tool
public enum BundledTemplateGroup: String, CaseIterable {
    public static let bundledTemplatesParentDirectoryName = "Templates"

    case StackGen_Swift_BuildSystem_Bazel
    case StackGen_Swift_BuildSystem_Cocoapods
    case StackGen_Swift_BuildSystem_Xcodegen
    case StackGen_Swift_Starter_CommandLine

    /// Obtain the template specification for the templates inside the template group
    public func convert() throws -> [TemplateSpec.Input] {
        let rootPath = try getRootPath()
        return templates.map {
            TemplateSpec.Input(
                .init(path: rootPath/$0.key),
                $0.value
            )
        }
    }

    /// Obtain the root path of the template group
    public func getRootPath() throws -> Path {
        let paths: [Path?] = [
            // First: check the bundled templates. They should be located next to the binary (follow symlinks if needed)
            try? Bundle.main.executable?.readlink().parent
                .join(Self.bundledTemplatesParentDirectoryName)
                .join(rawValue),
            // Second: check the path relative to this file (to be used during development)
            Path(#file)?.parent.parent.parent.parent
                .join(Self.bundledTemplatesParentDirectoryName)
                .join(rawValue)
            ]

        return try paths
            .compactMap { $0 }
            .first { $0.exists }
            .unwrap(onFailure: .templateGroupNotFound(identifier: rawValue))
    }

    /// The templates that each template group contains
    public var templates: [String: TemplateSpec.Mode] {
        switch self {
        case .StackGen_Swift_BuildSystem_Bazel:
            return [
                "module_app": .module(filter: ".*App.*"),
                "module": .module(),
                "root": .root,
                "root_tools": .root
            ]

        case .StackGen_Swift_BuildSystem_Cocoapods:
            return [
                "module_app": .module(filter: ".*App.*"),
                "moduleToRoot": .moduleToRoot(filter: "((?!App).)*"),
                "root": .root,
                "root_tools": .root
            ]

        case .StackGen_Swift_BuildSystem_Xcodegen:
            return [
                "module": .module(),
                "root": .root,
                "root_tools": .root
            ]

        case .StackGen_Swift_Starter_CommandLine:
            return [
                "root": .root
            ]
        }
    }
}
