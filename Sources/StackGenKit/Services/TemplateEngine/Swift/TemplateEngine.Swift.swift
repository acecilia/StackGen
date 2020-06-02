import Foundation
import SwiftTemplateEngine
import Path

extension TemplateEngine {
    /// A wrapper to render Swit templates
    public class Swift: TemplateEngineInterface {
        static let tmpDir: Path = Constant.tmpDir.join("swift_template")
        static let cacheDir: Path = tmpDir.join("cache")
        static let buildDir: Path = tmpDir.join("build")
        static let tmpTemplatesDir: Path = tmpDir.join("tmp_templates")

        public init(_ env: Env) throws {
            try Self.tmpTemplatesDir.mkdir(.p)
        }

        deinit {
            // Do not remove cache path or buildDir in order to speed up swift builds
            try? Self.tmpTemplatesDir.delete()
        }

        public func render(templateContent: String, context: Context.Output) throws -> String {
            let tmpFile = Self.tmpTemplatesDir/"template_content_\(templateContent.sha1()).txt"
            try templateContent.write(to: tmpFile)
            return try render(path: tmpFile, context: context)
        }

        public func render(path: Path, context: Context.Output) throws -> String {
            let cachePath = Self.cacheDir.join(path.string)
            try cachePath.mkdir(.p)

            let swiftTemplate = try SwiftTemplate(
                path: .init(path.string),
                makeMain: Self.makeMain,
                runtimeFiles: stackgenRuntimeFiles,
                manifestCode: Self.manifestCode,
                buildDir: .init(Self.buildDir.string), // Sharing the buildDir speeds up swift builds
                cachePath: .init(cachePath.string)
            )
            return try swiftTemplate.render(context)
        }
    }
}

extension TemplateEngine.Swift {
    private static let manifestCode = """
        // swift-tools-version:4.0
        // The swift-tools-version declares the minimum version of Swift required to build this package.
        import PackageDescription
        let package = Package(
            name: "SwiftTemplate",
            products: [
                .executable(name: "SwiftTemplate", targets: ["SwiftTemplate"])
            ],
            dependencies: [
                .package(url: "https://github.com/mxcl/Path.swift.git", .exact("1.0.1")),
                .package(url: "https://github.com/acecilia/StringCodable.git", .revision("b7d46cd32791753df1fe13b0b6ecdd9a19fbabcc")),
            ],
            targets: [
                .target(
                    name: "RuntimeCode",
                    dependencies: [
                        "Path",
                        "StringCodable",
                    ]
                ),
                .target(
                    name: "SwiftTemplate",
                    dependencies: [
                        "RuntimeCode",
                    ]
                ),
            ]
        )
        """

    private static func makeMain(_ template: String) -> String {
        """
        import Foundation
        import RuntimeCode

        extension String: Error { }

        do {
        \(template)
        } catch {
            throw error.finalDescription
        }
        """
    }
}
