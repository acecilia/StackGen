import Path
import Yams

public class FileIterator {
    public let options: Options

    public init(_ options: Options) {
        self.options = options
    }
    
    public func start() throws -> [Module] {
//        let configurationFiles = options.rootPath.find().type(.file).filter { $0.basename() == options.fileName }
//        let middlewareModules = try configurationFiles.map { try Module.Middleware($0) }
//        let modules = try middlewareModules.map { try Module($0, resolveDependenciesUsing: middlewareModules) }
//        return modules

        let path = options.rootPath/options.fileName
        let moduleFile = try ModuleFile.Yaml(path)
        guard let modules = moduleFile.modules else {
            fatalError("TODO")
        }
        let middlewareModules = modules.map { Module.Middleware(path: path/$0.key, yamlModule: $0.value) }
        return try middlewareModules.map { try Module($0, resolveDependenciesUsing: middlewareModules) }
    }
}
