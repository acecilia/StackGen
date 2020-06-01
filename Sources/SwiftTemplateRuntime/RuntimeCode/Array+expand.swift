import Foundation

public extension Array where Element == String {
    func expand() -> [Module] {
        self.map { moduleName in
            if let module = firstPartyModules.first(where: { $0.name == moduleName }) {
                return .firstParty(module)
            } else if let module = thirdPartyModules.first(where: { $0.name == moduleName }) {
                return .thirdParty(module)
            } else {
                fatalError("")
            }
        }
    }
}
