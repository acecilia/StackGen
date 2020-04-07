import Foundation
import Path

enum Template: String, CaseIterable {
    static var Swift_BuildSystem: [Template] {
        allCases.filter { $0.rawValue.contains(#function) }
    }

    case Swift_BuildSystem_Bazel
    case Swift_BuildSystem_Cocoapods
    case Swift_BuildSystem_Xcodegen

    var path: Path {
        return templatesPath/rawValue
    }

    var prefillPath: Path? {
        switch self {
        case .Swift_BuildSystem_Bazel, .Swift_BuildSystem_Xcodegen, .Swift_BuildSystem_Cocoapods:
            return examplesPath
        }
    }
}
