import Foundation
import CarthageKit
import XCDBLD
import Version
import Path

public class CarthageService {
    static let shared = CarthageService(Current.options.carthagePath)

    public let path: Path
    private var frameworksCache: [String: Version]?

    private init(_ path: Path) {
        self.path = path
    }

    private func getFrameworks() throws -> [String: Version] {
        if let frameworksCache = frameworksCache {
            return frameworksCache
        }

        var frameworks: [String: Version] = [:]

        let resolvedCartfileUrl = ResolvedCartfile.url(in: path.url)
        let resolvedCartfileContent = try String(contentsOf: resolvedCartfileUrl)
        let resolvedCartfile = try ResolvedCartfile.from(string: resolvedCartfileContent).get()
        for (dependency, pinnedVersion) in resolvedCartfile.dependencies {
            let versionFileURL = VersionFile.url(for: dependency, rootDirectoryURL: path.url)
            guard let versionFile = VersionFile(url: versionFileURL) else {
                // Version file not found for dependency
                continue
            }
            let version = try Version(tolerant: pinnedVersion.commitish)
                .unwrap(onFailure: "The Carthage version is not valid. Dependency: \(dependency.name). Version: \(pinnedVersion.commitish)")
            let frameworkNames = versionFile.iOS?.map { $0.name } ?? []
            for frameworkName in frameworkNames {
                frameworks[frameworkName] = version
            }
        }

        frameworksCache = frameworks
        return frameworks
    }

    public func version(for framework: String) throws -> Version {
        let dict = try getFrameworks()
        return try dict[framework].unwrap(onFailure: "No version found for framework '\(framework)'")
    }
}
