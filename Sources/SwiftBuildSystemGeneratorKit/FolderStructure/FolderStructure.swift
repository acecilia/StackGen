import Foundation

public enum FolderStructure: String, Codable {
    case gradle

    func build() -> FolderStructureInterface {
        switch self {
        case .gradle:
            return GradleFolderStructure("swift")
        }
    }
}
