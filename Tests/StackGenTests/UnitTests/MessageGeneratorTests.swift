import XCTest
import Yams
import StackGenCLI
import StackGenKit
import Path
import SwiftCLI
import Stencil

final class MessageGeneratorTests: XCTestCase {
    func testStencilErrors() throws {
        let builder = Builder()
        let messageGenerator = builder.makeMessageGenerator()
        let error = builder.makeStencilError()
        let errorDescription = messageGenerator.description(for: error)

        XCTAssertEqual(
            errorDescription,
            #"""
            💥 Error: 1:2: error: Variable could not be resolved
            {{custom.something}}
              ^~~~~~~~~~~~~~~~
            """#
        )
    }

    func testDecodingErrors() throws {
        let builder = Builder()
        let messageGenerator = builder.makeMessageGenerator()
        let error = builder.makeDecodingError()
        let errorDescription = messageGenerator.description(for: error)

        XCTAssertEqual(
            errorDescription,
            #"""
            💥 Error: the data couldn’t be read because it is missing.
            keyNotFound(CodingKeys(stringValue: "version", intValue: nil), Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "options", intValue: nil)], debugDescription: "No value associated with key CodingKeys(stringValue: \"version\", intValue: nil) (\"version\").", underlyingError: nil))
            """#
        )
    }

    func testStackGenErrors() throws {
        let builder = Builder()
        let messageGenerator = builder.makeMessageGenerator()
        let error = builder.makeStackGenError()
        let errorDescription = messageGenerator.description(for: error)

        XCTAssertEqual(
            errorDescription,
            #"""
            💥 Error: found multiple modules with the same name. This is not permitted, a module name must be unique. Duplicated modules: 'ModuleA'
            Error originated at file 'MessageGeneratorTests.swift', line '21'
            StackGenError(kind: StackGenKit.StackGenError.Kind.foundDuplicatedModules(["ModuleA"]), fileName: "MessageGeneratorTests.swift", line: 21)
            """#
        )
    }
}

enum EnumError: Error {
    case errorA
}

struct StructError: Error {
    let property = "a string"
}

private class Builder {
    var env: Env = Env()
    init() { }

    func makeMessageGenerator() -> MessageGenerator {
        return MessageGenerator(env)
    }

    func makeStackGenError() -> Error {
        return StackGenError(
            .foundDuplicatedModules(["ModuleA"]),
            file: "StackGenTests/MessageGeneratorTests.swift",
            line: 21
        )
    }

    func makeDecodingError() -> Error {
        let decoder = YAMLDecoder()
        do {
            _ = try decoder.decode(
                StackGenFile.self,
                from: """
                options: { }
                """
            )
            fatalError("This should have thrown")
        } catch {
            return error
        }
    }

    func makeStencilError() -> Error {
        let templateEngine = TemplateEngine(env)
        let templateContent = """
        {{custom.something}}
        """
        let context = Context.Output(
            env: Context.Env(root: env.cwd.output, output: env.cwd.output),
            global: [:],
            modules: [],
            module: nil
        )
        do {
            _ = try templateEngine.render(templateContent: templateContent, context: context)
            fatalError("This should have thrown")
        } catch {
            return error
        }
    }
}
