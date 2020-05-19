import Foundation
import Path

/// Global values to be injected in all template contexts
public struct Global: Codable, Hashable {
    /// The root path from where the tool runs
    public let root: Path.Output
    /// The output path of the file resulting from rendering a template with a context
    public let output: Path.Output
}
