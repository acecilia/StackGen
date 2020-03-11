import Foundation
import CarthageKit
import XCDBLD
import Version
import Path

public class CarthageService {
    public let path: Path
    private var frameworksCache: [String: Version]?

    public init(_ path: Path) {
        self.path = path
    }

    public func getFrameworks() throws -> [String: Version] {
        if let frameworksCache = frameworksCache {
            return frameworksCache
        }

        var frameworks: [String: Version] = [:]

        let resolvedCartfileUrl = ResolvedCartfile.url(in: path.url)
        if let resolvedCartfileContent = try? String(contentsOf: resolvedCartfileUrl) {
            let resolvedCartfile = try ResolvedCartfile.from(string: resolvedCartfileContent).get()
            for (dependency, pinnedVersion) in resolvedCartfile.dependencies {
                let versionFileURL = VersionFile.url(for: dependency, rootDirectoryURL: path.url)
                guard let versionFile = VersionFile(url: versionFileURL) else {
                    Reporter.warning("Carthage version file not found for dependency '\(dependency.name)'")
                    continue
                }
                let version = try Version(tolerant: pinnedVersion.commitish)
                    .unwrap(onFailure: "The Carthage version is not valid. Dependency: \(dependency.name). Version: \(pinnedVersion.commitish)")
                let frameworkNames = versionFile.iOS?.map { $0.name } ?? []
                for frameworkName in frameworkNames {
                    frameworks[frameworkName] = version
                }
            }
        } else {
            Reporter.warning("The 'Carthage.resolved' file was not found at path '\(resolvedCartfileUrl.absoluteString)'")
        }

        frameworksCache = frameworks
        return frameworks
    }
}
