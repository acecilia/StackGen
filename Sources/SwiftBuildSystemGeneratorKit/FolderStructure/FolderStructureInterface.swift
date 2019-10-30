import Foundation

protocol FolderStructureInterface: class {
    var sources: [File] { get }
    var resources: [File] { get }
    var tests: [File] { get }
    var testResources: [File] { get }
}

public enum FolderStructure: String, Codable {
    case gradle
    case SPM
}
