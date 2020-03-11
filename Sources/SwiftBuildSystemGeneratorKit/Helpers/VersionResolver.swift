import Foundation

class VersionResolver: Decodable {
    private let versionSpecs: [VersionSpec]

    init(_ versionSpecs: [VersionSpec]) {
        self.versionSpecs = versionSpecs
    }

    func resolve(dependencyName: String) throws -> Version {
        var versions: [(spec: VersionSpec, version: Version)] = []

        for versionSpec in versionSpecs {
            switch versionSpec {
            case .carthage: break // TODO
            case .custom(let name, let version):
                if name == dependencyName {
                    versions.append((versionSpec, version))
                }
            }
        }

        switch versions.count {
        case 0:
            throw CustomError(.versionCouldNotBeFoundForModule(dependencyName))

        case 1:
            return versions[0].version

        default:
            throw CustomError(.multipleVersionsFoundForModule(dependencyName, versions.map { $0.spec }))
        }
    }
}
