import Foundation
import Path
import Version

class VersionResolver {
    private static let versionRegex = NSRegularExpression(#"\d\.\d\.\d"#)
    private let sources: [Path]
    private let lines: [Line]

    init(_ sources: [Path]) throws {
        self.sources = sources
        self.lines = try sources.flatMap { source in
            try String(contentsOf: source).components(separatedBy: .newlines).enumerated().map {
                Line(source: source, index: $0.offset, content: $0.element)
            }
        }
    }

    func resolve(dependencyName: String) throws -> ThirdPartyModule.Output {
        let linesContainingDependency = lines.filter { $0.content.contains(dependencyName) }

        switch linesContainingDependency.count {
        case 0:
            throw CustomError(.moduleCouldNotBeFoundInSources(dependencyName, sources))

        case 1:
            let line = linesContainingDependency[0]
            let detectedVersions = VersionResolver.versionRegex.matches(in: line.content)
            switch detectedVersions.count {
            case 0:
                throw CustomError(.versionCouldNotBeFoundForModule(dependencyName, line))

            case 1:
                let versionString = detectedVersions[0]
                let version = try Version(tolerant: versionString)
                    .unwrap(onFailure: "Version '\(versionString)' is not valid for dependency '\(dependencyName)'")
                return ThirdPartyModule.Output(
                    source: line.source.output,
                    name: dependencyName,
                    version: version
                )

            default:
                throw CustomError(.multipleVersionsFoundForModule(dependencyName, [line]))
            }
        default:
            throw CustomError(.multipleVersionsFoundForModule(dependencyName, linesContainingDependency))
        }
    }
}

public struct Line {
    public let source: Path
    public let index: Int
    public let content: String
}
