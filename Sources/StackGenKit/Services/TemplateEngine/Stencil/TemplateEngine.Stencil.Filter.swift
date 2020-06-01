import Foundation
import Path

/// An interface shared between all stencil filters
public protocol StencilFilterInterface: class {
    static var filterName: String { get }
    var context: Context.Output? { get set }
    func run(_ value: Any?) throws -> Any
}

extension TemplateEngine.Stencil {
    /// A namespace grouping the stencil filters
    public enum Filter { }
}

extension TemplateEngine.Stencil.Filter {
    /// An stencil filter to check when a path exists on disk
    public class PathExists: StencilFilterInterface {
        public static let filterName = "pathExists"

        public var context: Context.Output?

        public func run(_ value: Any?) throws -> Any {
            let string = try value.asString(Self.filterName)
            let context = try self.context.unwrap(Self.filterName)
            let path = Path(string) ?? context.env.output.path.parent.join(string)
            return path.exists
        }
    }

    /// An stencil filter that returns the path relative to the root of the repository
    public class RelativeToRoot: StencilFilterInterface {
        public static let filterName = "rr"

        public var context: Context.Output?

        public func run(_ value: Any?) throws -> Any {
            let string = try value.asString(Self.filterName)
            let context = try self.context.unwrap(Self.filterName)
            let path = Path(string) ?? context.env.output.path.parent.join(string)
            return path.relative(to: context.env.root.path)
        }
    }

    /// An stencil filter that returns the path relative to the module being processed
    public class RelativeToModule: StencilFilterInterface {
        public static let filterName = "rm"

        public var context: Context.Output?

        public func run(_ value: Any?) throws -> Any {
            let string = try value.asString(Self.filterName)
            let context = try self.context.unwrap(Self.filterName)
            let path = Path(string) ?? context.env.output.path.parent.join(string)
            let module = try context.module.unwrap(Self.filterName)
            return path.relative(to: module.location.path)
        }
    }

    /// An stencil filter that returns the corresponding absolut path
    public class Absolut: StencilFilterInterface {
        public static let filterName = "abs"

        public var context: Context.Output?

        public func run(_ value: Any?) throws -> Any {
            let string = try value.asString(Self.filterName)
            let path = try Path(string) ?? context.unwrap(Self.filterName).env.output.path.parent.join(string)
            return path.relative(to: Path.root)
        }
    }

    /// An stencil filter that expands a list of dependency names to their corresponding module dictionaries
    public class ExpandDependencies: StencilFilterInterface {
        public static let filterName = "expand"

        public var context: Context.Output?

        public func run(_ value: Any?) throws -> Any {
            let dependencies = try value.asStringArray(Self.filterName)
            let context = try self.context.unwrap(Self.filterName)

            let expandedDependencies: [[String: Any]] = try dependencies.map { dependency in
                let dependency: Codable = try (
                    context.modules.first { $0.name == dependency }
                    )
                    .unwrap(onFailure: "A module with name '\(dependency)' could not be found")
                return try dependency.asDictionary(context.env.output.path.parent)
            }

            return expandedDependencies
        }
    }
}

private extension Optional where Wrapped == Any {
    func asString(_ filterName: String, file: String = #file, line: Int = #line) throws -> String {
        guard let unwrapped = self as? String else {
            throw StackGenError(.filterFailed(filter: filterName, reason: "The value passed to the filter is not a valid string"))
        }
        return unwrapped
    }

    func asStringArray(_ filterName: String, file: String = #file, line: Int = #line) throws -> [String] {
        guard let unwrapped = self as? [String] else {
            throw StackGenError(.filterFailed(filter: filterName, reason: "The value passed to the filter is not a valid string array"))
        }
        return unwrapped
    }
}


private extension Optional where Wrapped == Context.Output {
    func unwrap(_ filterName: String, file: String = #file, line: Int = #line) throws -> Wrapped {
        guard let unwrapped = self else {
            throw StackGenError(
                .unexpected("The context needed to compute the filter '\(filterName)' is not available"),
                file: file,
                line: line
            )
        }
        return unwrapped
    }
}

private extension Optional where Wrapped == FirstPartyModule.Output {
    func unwrap(_ filterName: String, file: String = #file, line: Int = #line) throws -> Wrapped {
        guard let unwrapped = self else {
            throw StackGenError(
                .unexpected("The module needed to compute the filter '\(filterName)' is not available"),
                file: file,
                line: line
            )
        }
        return unwrapped
    }
}
