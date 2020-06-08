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
    /// A stencil filter to check when a path exists on disk
    public class PathExists: StencilFilterInterface {
        public static let filterName = "pathExists"

        public var context: Context.Output?

        public func run(_ value: Any?) throws -> Any {
            let context = try self.context.unwrap(Self.filterName)
            let path = try value.asPath(context, Self.filterName)
            return path.exists
        }
    }

    /// A stencil filter that returns the path relative to the root of the repository
    public class RelativeToRoot: StencilFilterInterface {
        public static let filterName = "rr"

        public var context: Context.Output?

        public func run(_ value: Any?) throws -> Any {
            let context = try self.context.unwrap(Self.filterName)
            let path = try value.asPath(context, Self.filterName)
            return path.relative(to: context.env.root)
        }
    }

    /// A stencil filter that returns the path relative to the module being processed
    public class RelativeToModule: StencilFilterInterface {
        public static let filterName = "rm"

        public var context: Context.Output?

        public func run(_ value: Any?) throws -> Any {
            let context = try self.context.unwrap(Self.filterName)
            let path = try value.asPath(context, Self.filterName)
            let module = try context.module.unwrap(Self.filterName)
            return path.relative(to: module.path)
        }
    }

    /// A stencil filter that returns the corresponding absolut path
    public class Absolut: StencilFilterInterface {
        public static let filterName = "abs"

        public var context: Context.Output?

        public func run(_ value: Any?) throws -> Any {
            let context = try self.context.unwrap(Self.filterName)
            let path = try value.asPath(context, Self.filterName)
            return path.relative(to: Path.root)
        }
    }

    /// A stencil filter that returns the basename of a path
    public class Basename: StencilFilterInterface {
        public static let filterName = "basename"

        public var context: Context.Output?

        public func run(_ value: Any?) throws -> Any {
            let context = try self.context.unwrap(Self.filterName)
            let path = try value.asPath(context, Self.filterName)
            return path.basename()
        }
    }

    /// A stencil filter that returns the parent of a path
    public class Parent: StencilFilterInterface {
        public static let filterName = "parent"

        public var context: Context.Output?

        public func run(_ value: Any?) throws -> Any {
            let context = try self.context.unwrap(Self.filterName)
            let path = try value.asPath(context, Self.filterName)
            return path.parent.relative(to: context.env.output.parent)
        }
    }

    /// A stencil filter that expands a list of dependency names to their corresponding module dictionaries
    public class ExpandDependencies: StencilFilterInterface {
        public static let filterName = "expand"

        public var context: Context.Output?

        public func run(_ value: Any?) throws -> Any {
            let dependencies = try value.asStringArray(Self.filterName)
            let context = try self.context.unwrap(Self.filterName)

            let expandedDependencies: [[String: Any]] = try dependencies.map { dependency in
                let dependency: Codable = try context.modules
                    .first { $0.name == dependency }
                    .unwrap(
                        onFailure: .unknownModule(
                            dependency,
                            context.modules.firstParty.map { $0.name },
                            context.modules.thirdParty.map { $0.name }
                        )
                )
                return try dependency.asDictionary(context.env.output.parent)
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

    func asPath(_ context: Context.Output, _ filterName: String, file: String = #file, line: Int = #line) throws -> Path {
        let string = try self.asString(filterName, file: file, line: line)
        return Path(string) ?? context.env.output.parent.join(string)
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
