import Foundation

public extension Array where Element == String {
    func expand() -> [Module] {
        self.map { moduleName in
            guard let module = modules.first(where: { $0.name == moduleName }) else {
                fatalError("")
            }
            return module
        }
    }
}
