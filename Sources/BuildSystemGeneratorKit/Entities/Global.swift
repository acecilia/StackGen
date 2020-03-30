import Foundation
import Path

public struct Global: Codable {
    public let rootPath: Path
    public let templatesPath: Path
    public let fileName: String
}
