import Foundation
import Path

public var cwd: Path {
    return Path(Path.cwd)
}

public private(set) var Current: World {
    get { return _Current }
    set { _Current = newValue }
}

private var _Current: World!

public func setCurrent(_ commandLineOptions: Options.Yaml) throws {
    let workspace = try Workspace.decode(from: cwd)
    let options = Options(
        yaml: commandLineOptions.merge(with: workspace.options)
    )
    let globals = Globals(workspace.globals, templatePath: options.templatePath)
    Current = World(options, globals)
}

public struct World {
    public let options: Options
    public let globals: Globals
    public let carthageService: CarthageService

    public init(_ options: Options, _ globals: Globals) {
        self.options = options
        self.globals = globals
        self.carthageService = CarthageService(options.carthagePath)
    }
}
