import Foundation
import Path

public struct TemplateResolver {
    private static let bundledTemplateFileName = "templates.yml"
    private static let bundledTemplatesDirectoryName = "Templates"

    private let env: Env

    public init(_ env: Env) {
        self.env = env
    }

    public func resolveTemplate(_ relativePath: String) throws -> Path {
        let paths: [Path?] = [
            // First: treat as absolut path
            Path(relativePath),
            // Second: check relative to the current location
            env.cwd/relativePath,
            // Third: check the bundled templates. They should be located next to the binary (follow symlinks if needed)
            try? Bundle.main.executable?.readlink().parent
                .join(Self.bundledTemplatesDirectoryName)
                .join(relativePath)
                .join(Self.bundledTemplateFileName),
            // Fourth: check the path relative to this file (to be used during development)
            Path(#file)?.parent.parent.parent.parent
                .join(Self.bundledTemplatesDirectoryName)
                .join(relativePath)
                .join(Self.bundledTemplateFileName)
            ]

        let templateFile = try paths
            .compactMap { $0 }
            .first { $0.exists }
            .unwrap(onFailure: .templatesFileNotFound(relativePath: relativePath))

        env.reporter.info(.pageFacingUp, "using template file at path \(templateFile.relative(to: env.cwd))")

        return templateFile
    }
}
