import Foundation
import CarthageKit
import XCDBLD
import Version
import Path

public class CarthageService {
    static let shared = CarthageService(Current.options.carthagePath)

    public let path: Path
    private var frameworksCache: [Framework]?

    private init(_ path: Path) {
        self.path = path
    }

    public func getFrameworks() throws -> [Framework] {
        if let frameworksCache = frameworksCache {
            return frameworksCache
        }

        var frameworks: [Framework] = []

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
                frameworks.append(Framework(frameworkName, version))
            }
        }

        frameworksCache = frameworks
        return frameworks
    }
}

public extension CarthageService {
    struct Framework {
        public let name: String
        public let version: Version

        public init(_ name: String, _ version: Version) {
            self.name = name
            self.version = version
        }
    }
}
