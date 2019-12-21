import Foundation
import Path

extension Dependency {
    public enum Yaml: AutoCodable {
        case module(Path)
        case framework(String)
    }
}
