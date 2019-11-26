import Foundation
import Path

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

private var cwd: Path { Path(Path.cwd) }

public struct World {
    public var wd: Path { cwd }
    public var options: Options
    public var globals: Globals

    public init(_ options: Options, _ globals: Globals) {
        self.options = options
        self.globals = globals
    }
}
