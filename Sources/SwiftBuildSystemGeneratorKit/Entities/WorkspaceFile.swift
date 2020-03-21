import Foundation

struct WorkspaceFile: Decodable {
    @RawWrapper
    private(set) var global: Global
    var options: Options
    let modules: [Module.Input]
    let dependencies: [Path]
}
