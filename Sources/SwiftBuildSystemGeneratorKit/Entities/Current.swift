import Foundation
import Path

public var cwd: Path {
    return Path(Path.cwd)
}

public internal (set) var Current: World {
    get { return _Current }
    set { _Current = newValue }
}

private var _Current: World!

public func setCurrent(_ commandLineOptions: Options.Yaml) throws {
    let workspace = try Workspace.decode(from: cwd)
    let options = Options(
        yaml: commandLineOptions.merge(with: workspace.options)
    )
    let globals = Globals(workspace.globals)
    Current = World(options, globals)
}

public struct World {
    public var options: Options
    public var globals: Globals

    public init(_ options: Options, _ globals: Globals) {
        self.options = options
        self.globals = globals
    }
}
