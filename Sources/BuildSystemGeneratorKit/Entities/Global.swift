import Foundation
import Path

public struct Global: Codable, Hashable {
    // Constants
    public let root: Path
    public let rootBasename: String

    // Variables
    public let parent: Path
    public let fileName: String
}
