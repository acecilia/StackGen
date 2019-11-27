import Foundation

protocol FolderStructureInterface: class {
    func testTargetName(for targetName: String) -> String
    var sources: [String] { get }
//    var resources: [String] { get }
    var tests: [String] { get }
//    var testResources: [String] { get }
}

extension FolderStructureInterface {
    func testTargetName(for targetName: String) -> String {
        return "\(targetName)Tests"
    }
}
