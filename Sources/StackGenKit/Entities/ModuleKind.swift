import Foundation

public enum ModuleKind: String, Codable, CaseIterable, Comparable {
    case firstParty
    case thirdParty

    public static func < (lhs: Self, rhs: Self) -> Bool {
        return allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}
