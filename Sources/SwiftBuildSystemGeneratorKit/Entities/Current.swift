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
    Current = World(options, workspace.globals)
}

public struct World {
    public let options: Options
    @RawWrapper
    public var globals: Global
    public let carthageService: CarthageService

    public init(_ options: Options, _ globals: RawWrapper<Global>) {
        self.options = options
        self._globals = globals
        self.carthageService = CarthageService(options.carthagePath)
    }
}
