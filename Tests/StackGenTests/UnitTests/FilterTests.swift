import XCTest
import Yams
import StackGenKit
import Path

final class FilterTests: XCTestCase {
    func testAbsolute() throws {
        let builder = Builder()
        let filter: TemplateEngine.Stencil.Filter.Absolute = builder.makeFilter()
        let path = try filter.run("somePath") as? String
        XCTAssertEqual(path, "/root/Module/somePath")
    }

    func testPathExists() throws {
        let builder = Builder()
        let filter: TemplateEngine.Stencil.Filter.PathExists = builder.makeFilter()
        let exists = try filter.run("somePath") as? Bool
        XCTAssertEqual(exists, false)
    }

    func testRelativeToRoot() throws {
        let builder = Builder()
        let filter: TemplateEngine.Stencil.Filter.RelativeToRoot = builder.makeFilter()
        let path = try filter.run("somePath") as? String
        XCTAssertEqual(path, "Module/somePath")
    }

    func testRelativeToModule() throws {
        let builder = Builder()
        let filter: TemplateEngine.Stencil.Filter.RelativeToModule = builder.makeFilter()
        let path = try filter.run("somePath") as? String
        XCTAssertEqual(path, "somePath")
    }

    func testBasename() throws {
        let builder = Builder()
        let filter: TemplateEngine.Stencil.Filter.Basename = builder.makeFilter()
        let basename = try filter.run("file.yml") as? String
        XCTAssertEqual(basename, "file.yml")
    }

    func testParent() throws {
        let builder = Builder()
        let filter: TemplateEngine.Stencil.Filter.Parent = builder.makeFilter()
        let path = try filter.run("parentPath/somePath") as? String
        XCTAssertEqual(path, "parentPath")
    }

    func testExpandDependencies() throws {
        let builder = Builder()
        let filter: TemplateEngine.Stencil.Filter.ExpandDependencies = builder.makeFilter()
        let dependencies = try filter.run(["Dependency"]) as? [[String: Any]]
        XCTAssertEqual(dependencies?.count, 1)
    }
}

private class Builder {
    lazy var rootPath: Path = Path.root/"root"
    lazy var modulePath: Path = rootPath/"Module"
    lazy var outputPath: Path = modulePath/"output.yml"
    lazy var dependencyPath: Path = rootPath/"Dependency"
    lazy var module = FirstPartyModule.Output(
        name: "Module",
        path: modulePath,
        dependencies: ["main" : ["Depenedency"]],
        transitiveDependencies: [:]
    )
    lazy var dependency = FirstPartyModule.Output(
        name: "Dependency",
        path: dependencyPath,
        dependencies: [:],
        transitiveDependencies: [:]
    )

    func makeFilter<T: TemplateEngine.Stencil.Filter.Base>() -> T {
        let context = Context.Output(
            env: .init(root: rootPath, output: outputPath),
            global: [:],
            modules: [.firstParty(module), .firstParty(dependency)],
            module: module
        )
        return .init(context: context)
    }
}
