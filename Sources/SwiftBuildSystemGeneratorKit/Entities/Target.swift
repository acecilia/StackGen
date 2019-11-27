import Foundation
import Path

public struct Target: Encodable, Hashable {
    public let name: String
    public let sources: [Path]
    public let dependencies: [Dependency]
}
