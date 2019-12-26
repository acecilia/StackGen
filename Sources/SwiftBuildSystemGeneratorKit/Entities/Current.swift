import Foundation
import Path

public var cwd: Path {
    return Path(Path.cwd)
}

public var Current: World { _Current }
private var _Current: World!

public func setCurrent(_ commandLineOptions: Options.Yaml) throws {
    let workspace = try Workspace.decode(from: cwd)
    let options = Options(
        yaml: commandLineOptions.merging(workspace.options)
    )
    _Current = World(options, workspace.globals)
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
