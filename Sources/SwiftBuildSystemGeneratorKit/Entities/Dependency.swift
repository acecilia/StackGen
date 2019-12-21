import Foundation
import Path
import AnyCodable
import Version

public struct Dependency: Encodable, Hashable, ContextConvertible {
    public let name: String
    public let path: Path
    public let version: Version
    public let type: Kind

    public init(_ middlewareModule: Module.Middleware) {
        self.name = middlewareModule.name
        self.path = middlewareModule.path
        self.version = Current.globals.version
        self.type = .module
    }

    public init(_ framework: CarthageService.Framework) {
        self.name = framework.name
        // Only support dynamic linked frameworks for now
        self.path = Current.options.carthagePath/"Carthage"/"Build"/"iOS"/"\(name).framework"
        self.version = framework.version
        self.type = .framework
    }
}

public extension Dependency {
    enum Kind: String, Codable {
        case module
        case framework
    }
}
