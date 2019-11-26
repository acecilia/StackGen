import Foundation
import Path
import Version

public struct Framework: Encodable, ContextConvertible {
    public let name: String
    public let version: Version
    public let path: Path

    init(name: String, version: Version) {
        self.name = name
        self.version = version
        self.path = Current.wd/"Carthage"/"Build"/"iOS"/"\(name).framework"
    }
}
