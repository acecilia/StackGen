import Foundation

protocol FolderStructureInterface: class {
    var sources: [String] { get }
    var resources: [String] { get }
    var tests: [String] { get }
    var testResources: [String] { get }
}

public enum FolderStructure: String, Codable {
    case gradle
}
