import Foundation

/// Extension used to convert the dependencies of a module from a list of names to the full module types
public extension Array where Element == String {
    func expand() throws -> [Module] {
        try self.map { moduleName in
            guard let module = modules.first(where: { $0.name == moduleName }) else {
                throw StackGenError(.unknownModuleName(moduleName, modules))
            }
            return module
        }
    }
}
