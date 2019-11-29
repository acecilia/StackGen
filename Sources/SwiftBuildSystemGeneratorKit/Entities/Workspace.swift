import Foundation
import Path
import Yams
import Version

public struct Workspace: Codable {
    public let options: Options.Yaml?
    public let globals: Globals.Yaml

    public static func decode(from path: Path) throws -> Workspace {
        let content = try String(contentsOf: path/"workspace.yml")
        let userInfo: [CodingUserInfoKey: Any] = [
            .relativePath: path,
            .tolerantVersion: true
        ]
        return try YAMLDecoder().decode(Workspace.self, from: content, userInfo: userInfo)
    }
}
