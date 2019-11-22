import Foundation
import Path

public struct Target: Codable {
    public let name: String
    public let sources: [Path]
    public let dependencies: [Module]
}
