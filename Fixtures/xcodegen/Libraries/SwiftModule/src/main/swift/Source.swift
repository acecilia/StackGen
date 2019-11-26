import Foundation
import SwiftModule2
import FileKit

public let moduleName = String(reflecting: AnyClass.self).components(separatedBy:".").first!
public let dependency1Name = SwiftModule2.moduleName
public let fileKitName = String(reflecting: TextFile.self).components(separatedBy:".").first!

private class AnyClass {
    init() { }
}
