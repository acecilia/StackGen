import Foundation
import Path

public struct Global: Codable {
    // Constants
    public let rootPath: Path
    public let templatesPath: Path

    // Variables
    public let parentPath: Path
    public let fileName: String
}
