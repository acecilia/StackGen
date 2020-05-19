import Foundation

public let moduleName = String(reflecting: AnyClass.self).components(separatedBy:".").first!

private class AnyClass {
    init() { }
}
