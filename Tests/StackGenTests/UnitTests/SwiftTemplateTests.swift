import Foundation
import XCTest
import StackGenKit
import Path

final class SwiftTemplateTests: XCTestCase {
    func test() throws {
        let builder = Builder()
        let swiftTemplateEngine = try TemplateEngine.Swift(builder.env)
        let context = builder.makeContext()

        do {
            let result = try swiftTemplateEngine.render(
                template: .init(#"<%= global["contextId"]! %>"#),
                context: context
            )
            XCTAssertEqual(result, builder.contextId)
        } catch {
            XCTFail("\(error)")
        }
    }
}

private class Builder {
    var env = Env()
    var contextId = UUID().uuidString

    func makeContext() -> Context.Output {
        let outputContext = Context.Output(
            env: Context.Env(root: env.root, output: Path(Path.cwd)),
            global: ["contextId": .init(contextId)],
            modules: [],
            module: nil
        )

        return outputContext
    }
}
