import Foundation
import Path

protocol Filter: class {
    static var filterName: String { get }
    var context: MainContext? { get set }
    func run(_ value: Any?) throws -> Any
}

class PathExistsFilter: Filter {
    static let filterName = "pathExists"

    var context: MainContext?

    func run(_ value: Any?) throws -> Any {
        guard let string = value as? String else {
            throw CustomError(.filterFailed(filter: Self.filterName, reason: "The value passed to the filter is not a valid string"))
        }

        let path = try Path(string) ?? context.unwrap(Self.filterName).global.output.path.parent.join(string)
        return path.exists
    }
}

class RelativeToRootFilter: Filter {
    static let filterName = "rr"

    var context: MainContext?

    func run(_ value: Any?) throws -> Any {
        let string = try value.asString(Self.filterName)
        let context = try self.context.unwrap(Self.filterName)
        let path = Path(string) ?? context.global.output.path.parent.join(string)
        return path.relative(to: context.global.root.path)
    }
}

class RelativeToModuleFilter: Filter {
    static let filterName = "rm"

    var context: MainContext?

    func run(_ value: Any?) throws -> Any {
        let string = try value.asString(Self.filterName)
        let context = try self.context.unwrap(Self.filterName)
        let path = Path(string) ?? context.global.output.path.parent.join(string)
        let module = try context.module.unwrap(Self.filterName)
        return path.relative(to: module.location.path)
    }
}

class AbsolutFilter: Filter {
    static let filterName = "abs"

    var context: MainContext?

    func run(_ value: Any?) throws -> Any {
        let string = try value.asString(Self.filterName)
        let path = try Path(string) ?? context.unwrap(Self.filterName).global.output.path.parent.join(string)
        return path.relative(to: Path.root)
    }
}

class ExpandDependenciesFilter: Filter {
    static let filterName = "expand"

    var context: MainContext?

    func run(_ value: Any?) throws -> Any {
        let dependencies = try value.asStringArray(Self.filterName)
        let context = try self.context.unwrap(Self.filterName)

        let expandedDependencies: [[String: Any]] = try dependencies.map { dependency in
            let dependency: Codable = try context.firstPartyModules.first { $0.name == dependency } ??
                context.thirdPartyModules.first { $0.name == dependency }
                .unwrap(onFailure: "A module with name '\(dependency)' could not be found")
            return try dependency.asDictionary(context.global.output.path.parent)
        }

        return expandedDependencies
    }
}

private extension Optional where Wrapped == Any {
    func asString(_ filterName: String, file: String = #file, line: Int = #line) throws -> String {
        guard let unwrapped = self as? String else {
            throw CustomError(.filterFailed(filter: filterName, reason: "The value passed to the filter is not a valid string"))
        }
        return unwrapped
    }

    func asStringArray(_ filterName: String, file: String = #file, line: Int = #line) throws -> [String] {
        guard let unwrapped = self as? [String] else {
            throw CustomError(.filterFailed(filter: filterName, reason: "The value passed to the filter is not a valid string array"))
        }
        return unwrapped
    }
}


private extension Optional where Wrapped == MainContext {
    func unwrap(_ filterName: String, file: String = #file, line: Int = #line) throws -> Wrapped {
        guard let unwrapped = self else {
            throw UnexpectedError("The context needed to compute the filter '\(filterName)' is not available", file: file, line: line)
        }
        return unwrapped
    }
}

private extension Optional where Wrapped == FirstPartyModule.Output {
    func unwrap(_ filterName: String, file: String = #file, line: Int = #line) throws -> Wrapped {
        guard let unwrapped = self else {
            throw UnexpectedError("The module needed to compute the filter '\(filterName)' is not available", file: file, line: line)
        }
        return unwrapped
    }
}
