import Foundation
import SwiftTemplateEngine
import SourceryUtils
import Path

extension TemplateEngine {
    /// A wrapper to render stencil templates
    public class Swift: TemplateEngineInterface {
        private static let version: String? = SourceryVersion.current.value

        /// Copied from Sourcery file SwiftTemplate.swift
        static let buildDir: Path = {
            let pathComponent = "SwiftTemplate" + (version.map { "/\($0)" } ?? "")
            guard let tempDirURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(pathComponent) else { fatalError("Unable to get temporary path") }
            return Path.root/tempDirURL.path
        }()

        public init(_ env: Env) throws {
            try Self.buildDir.mkdir(.p)
        }

        deinit {
            try? Self.buildDir.delete()
        }

        public func render(templateContent: String, context: Context.Middleware) throws -> String {
            let tmpFile = Self.buildDir/UUID().uuidString
            try templateContent.write(to: tmpFile)
            let swiftTemplate = try SwiftTemplate(
                path: .init(tmpFile.string),
                cachePath: nil,
                version: Self.version,
                prefix: "",
                runtimeFiles: []
            )
            return try swiftTemplate.render(context)
        }
    }
}
