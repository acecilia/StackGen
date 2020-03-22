import Foundation

struct WorkspaceFile: Decodable {
    let global: [String: String]
    let options: Options
    let modules: [FirstPartyModule.Input]
    let versionSources: [Path]
}
