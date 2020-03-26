import Foundation
import SwiftModule2
import SnapKit

public let moduleName = String(reflecting: AnyClass.self).components(separatedBy:".").first!
public let module2Name = SwiftModule2.moduleName
public let snapKitName = String(reflecting: Constraint.self).components(separatedBy:".").first!

private class AnyClass {
    init() { }
}
