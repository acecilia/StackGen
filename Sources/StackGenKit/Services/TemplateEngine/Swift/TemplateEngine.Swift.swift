import Foundation
import SwiftTemplateEngine
import Path

extension TemplateEngine {
    /// A wrapper to render Swit templates
    public class Swift: TemplateEngineInterface {
        static let buildDir: Path = Path(NSTemporaryDirectory())!/"StackGen/SwiftTemplate"

        public init(_ env: Env) throws {
            try Self.buildDir.mkdir(.p)
        }

        deinit {
            // Do NOT clean up the buildDir: it will speed up execution of swift templates
            // try? Self.buildDir.delete()
        }

        public func render(templateContent: String, context: Context.Output) throws -> String {
            let tmpFile = Self.buildDir/"tmp_template_content.txt"
            try templateContent.write(to: tmpFile)
            return try render(path: tmpFile, context: context)
        }

        public func render(path: Path, context: Context.Output) throws -> String {
            let swiftTemplate = try SwiftTemplate(
                path: .init(path.string),
                prefix: """
                import Foundation
                import RuntimeCode
                """,
                runtimeFiles: stackgenRuntimeFiles,
                manifestCode: """
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
                        .package(url: "https://github.com/acecilia/Compose.git", .exact("0.0.4")),
                        .package(url: "https://github.com/acecilia/StringCodable.git", .revision("b7d46cd32791753df1fe13b0b6ecdd9a19fbabcc")),
                    ],
                    targets: [
                        .target(
                            name: "RuntimeCode",
                            dependencies: [
                                "Path",
                                "Compose",
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
                """,
                buildDir: .init(Self.buildDir.string),
                cachePath: nil
            )
            return try swiftTemplate.render(context)
        }
    }
}
