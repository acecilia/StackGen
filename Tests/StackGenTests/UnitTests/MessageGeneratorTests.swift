import XCTest
import Yams
import StackGenCLI
import StackGenKit
import Path
import SwiftCLI
import Stencil

final class MessageGeneratorTests: XCTestCase {
    func testMessageGenerator() throws {
        let builder = Builder()
        let sut = builder.makeSut()

        let stencilError = TemplateSyntaxError(reason: "Stencil template is wrong")
        let error = CustomError(.errorThrownWhileRendering(templatePath: "template/path", error: stencilError))
        let errorDescription = sut.description(for: error)

        XCTAssertEqual(
            errorDescription,
            """
            💥 Error: error thrown while rendering template at path 'template/path'
            Stencil template is wrong
            Error originated at file 'MessageGeneratorTests.swift', line '15'
            """
        )
    }

    func testUsefulErrorDescription() {
        do {
            let error = EnumError.errorA
            XCTAssertEqual(
                error.localizedDescription,
                #"The operation couldn’t be completed. (StackGenTests.EnumError error 0.)"#
            )
            XCTAssertEqual(
                error.usefulDescription,
                #"The operation couldn’t be completed. (StackGenTests.EnumError error 0.). errorA"#
            )
        }

        do {
            let error = StructError()
            XCTAssertEqual(
                error.localizedDescription,
                #"The operation couldn’t be completed. (StackGenTests.StructError error 1.)"#
            )
            XCTAssertEqual(
                error.usefulDescription,
                #"The operation couldn’t be completed. (StackGenTests.StructError error 1.). StructError(property: "a string")"#
            )
        }
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

    func makeSut() -> MessageGenerator {
        return MessageGenerator(env)
    }
}
