import Foundation
import Path
import StackGenKit

typealias Template = BundledTemplateGroup

extension BundledTemplateGroup {
    static var Swift_BuildSystem: [Template] {
        allCases.filter { $0.rawValue.contains(#function) }
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
