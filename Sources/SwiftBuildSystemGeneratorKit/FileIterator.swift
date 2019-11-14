import Path
import Yams

public class FileIterator {
    static let defaultFileName = "Module.yml"
    static let defaultTemplatePath = "templates"

    public init() { }
    
    public func start(_ rootPath: Path) throws -> [Module] {
        let configurationFiles = rootPath.find().type(.file).filter { $0.basename() == Self.defaultFileName }
        let middlewareModules = try configurationFiles.map { try Module.Middleware($0) }
        let modules = try middlewareModules.map { try Module($0, resolveDependenciesUsing: middlewareModules) }
        return modules
    }
}
