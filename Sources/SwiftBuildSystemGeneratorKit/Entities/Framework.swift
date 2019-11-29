import Foundation
import Path
import Version

public struct Framework: Encodable, Hashable, ContextConvertible {
    public let name: String
    public let version: Version
    public let path: Path

    init(name: String, version: Version) {
        self.name = name
        self.version = version
        // Only support dynamic linked frameworks for now
        self.path = Current.options.carthagePath/"Carthage"/"Build"/"iOS"/"\(name).framework"
    }
}
