import Stencil
import Path

public class XcodegenGenerator: FileGeneratorInterface {
    public static let outputFileName = "project.yml"

    private let modules: [Module]
    public init(_ modules: [Module]) {
        self.modules = modules
    }

    public func generate() throws {
        for module in modules {
            let environment = Environment(loader: FileSystemLoader(paths: ["templates/"]))
            let rendered = try environment.renderTemplate(name: Self.outputFileName, context: try module.asDictionary())
            
            let outputPath = module.path/Self.outputFileName
            try outputPath.delete()
            try rendered.write(to: outputPath)
        }
    }
}
