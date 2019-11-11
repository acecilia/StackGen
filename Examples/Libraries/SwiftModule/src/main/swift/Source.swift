import Foundation
import SwiftModule2

public let moduleName = String(reflecting: AnyClass.self).components(separatedBy:".").first!
public let dependency1Name = SwiftModule2.moduleName

private class AnyClass {
    init() { }
}
