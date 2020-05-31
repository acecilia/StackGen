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
                templateContent: #"<%= context.output.global["contextId"]! %>"#,
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

    func makeContext() -> Context.Middleware {
        let outputContext = Context.Output(
            env: Context.Env(root: env.root.output, output: Path(Path.cwd).output),
            global: ["contextId": .init(contextId)],
            firstPartyModules: [],
            thirdPartyModules: [],
            module: nil
        )

        let middlewareContext = Context.Middleware(
            firstPartyModules: [],
            thirdPartyModules: [],
            output: outputContext
        )

        return middlewareContext
    }
}
