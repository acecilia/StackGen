import Foundation
import Path

public struct Global: Codable {
    // Constants
    public let root: Path
    public let rootBasename: String
    public let templatesPath: Path

    // Variables
    public let parent: Path
    public let fileName: String
}
