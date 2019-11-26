import Path
import Yams

public class FileIterator {
    public init() { }
    
    public func start() throws -> [Module] {
        let configurationFiles = Current.wd.find().type(.file).filter { $0.basename() == Current.options.fileName }
        let middlewareModules = try configurationFiles.map { try Module.Middleware($0) }
        let modules = try middlewareModules.map { try Module($0, resolveDependenciesUsing: middlewareModules) }
        return modules
    }
}
