import Foundation
import Path
import StackGenKit

typealias Template = BundledTemplateGroup

extension BundledTemplateGroup {
    static var Swift_BuildSystem: [Template] {
        return [.StackGen_Swift_BuildSystem_Cocoapods]
    }

    var path: Path { try! getRootPath() }

    var prefillPath: Path? {
        switch self {
        case .StackGen_Swift_BuildSystem_Bazel,
             .StackGen_Swift_BuildSystem_Xcodegen,
             .StackGen_Swift_BuildSystem_Cocoapods:
            return examplesPath

        case .StackGen_Swift_Starter_CommandLine:
            return nil
        }
    }
}
