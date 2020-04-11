import Foundation
import Path
import SwiftCLI

extension Path: ConvertibleFromString {
    public init?(input: String) {
        self = Path(input) ?? Path.cwd/input
    }
}
