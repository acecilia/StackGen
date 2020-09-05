import XCTest
import Yams
import StackGenKit
import Path

final class FilterTests: XCTestCase {
    func testAbs() throws {
        let builder = Builder()
        let filter: TemplateEngine.Stencil.Filter.Absolut = builder.makeFilter()
        let absolutPath = try filter.run("somePath")
        XCTAssertEqual(absolutPath as? String, "/level1/somePath")
    }
}

private class Builder {
    lazy var rootPath: Path = Path.root/"level1"
    lazy var outputPath: Path = rootPath/"level2"

    func makeFilter<T: TemplateEngine.Stencil.Filter.Base>() -> T {
        let context = Context.Output(
            env: .init(root: rootPath, output: outputPath),
            global: [:],
            modules: [],
            module: nil
        )
        return .init(context: context)
    }
}
