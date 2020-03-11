import Foundation

struct WorkspaceFile: Decodable {
    @RawWrapper
    private(set) var globals: Global
    var options: Options
    let firstParty: [Module.Input]
    let artifacts: [Artifact.Input]
    let versionSpecs: [VersionSpec]
}
