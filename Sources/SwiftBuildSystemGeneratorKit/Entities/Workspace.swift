import Foundation
import Path
import Yams

public struct Workspace: Codable {
    public let options: Options.Yaml?
    public let globals: Globals.Yaml

    public static func decode(from path: Path) throws -> Workspace {
        let content = try String(contentsOf: path/"workspace.yml")
        return try YAMLDecoder().decode(Workspace.self, from: content, userInfo: [.relativePath: path])
    }
}
