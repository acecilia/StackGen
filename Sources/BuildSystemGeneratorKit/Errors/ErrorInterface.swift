import Foundation

public protocol ErrorInterface: CustomStringConvertible {
    var fileName: String { get }
    var line: Int { get }
}
