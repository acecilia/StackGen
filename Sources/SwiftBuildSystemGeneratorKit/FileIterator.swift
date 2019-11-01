import Path
import Yams

public class FileIterator {
    static let defaultFileName = "Module.yml"
    static let defaultTemplatePath = "templates"

    public init() { }
    
    public func start(_ rootPath: Path) throws -> [Module] {
        let configurationFiles = rootPath.find().type(.file).filter { $0.basename() == Self.defaultFileName }
        let rawModules = try configurationFiles.map { try RawModule($0) }
        let modules = try rawModules.map { try Module($0, resolveDependenciesUsing: rawModules) }
        return modules
    }
}
