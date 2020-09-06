import XCTest
import StackGenKit
import Path

final class LinterTests: XCTestCase {
    func testModuleSorting() throws {
        do {
            let builder = Builder()
            builder.thirdPartyModules = ["A", "b", "C"]
            XCTAssertEqual(try builder.makeError(), nil)
        }

        do {
            let builder = Builder()
            builder.thirdPartyModules = ["B", "A"]
            XCTAssertEqual(
                try builder.makeError(),
                StackGenError.Kind.modulesSorting(builder.thirdPartyModules, ["A", "B"])
            )
        }

        do {
            let builder = Builder()
            builder.firstPartyModules = [
                .init(path: "A/D", dependencies: [:]),
                .init(path: "B/C", dependencies: [:])
            ]
            XCTAssertEqual(
                try builder.makeError(),
                StackGenError.Kind.modulesSorting(
                    builder.firstPartyModules.map { $0.name },
                    ["C", "D"]
                )
            )
        }
    }

    func testDependencySorting() {
        do {
            let builder = Builder()
            builder.firstPartyModules = [
                .init(path: "A", dependencies: ["main": ["B", "c", "D"]])
            ]
            builder.thirdPartyModules = ["B", "c", "D"]
            XCTAssertEqual(try builder.makeError(), nil)
        }

        do {
            let builder = Builder()
            builder.firstPartyModules = [
                .init(path: "A", dependencies: ["main": ["C", "B"]])
            ]
            builder.thirdPartyModules = ["B", "C"]

            XCTAssertEqual(
                try builder.makeError(),
                StackGenError.Kind.dependenciesSorting(
                    builder.firstPartyModules.first!.name,
                    builder.firstPartyModules.first!.dependencies.first!.key,
                    builder.firstPartyModules.first!.dependencies.first!.value,
                    ["B", "C"]
                )
            )
        }

        do {
            let builder = Builder()
            builder.firstPartyModules = [
                .init(path: "A", dependencies: ["main": ["E", "C", "D", "B"]]),
                .init(path: "B", dependencies: [:]),
                .init(path: "C", dependencies: [:])
            ]
            builder.thirdPartyModules = ["D", "E"]

            XCTAssertEqual(
                try builder.makeError(),
                StackGenError.Kind.dependenciesSorting(
                    builder.firstPartyModules.first!.name,
                    builder.firstPartyModules.first!.dependencies.first!.key,
                    builder.firstPartyModules.first!.dependencies.first!.value,
                    ["B", "C", "D", "E"]
                )
            )
        }
    }

    func testTransitiveDependenciesDuplication() {
        do {
            let builder = Builder()
            builder.firstPartyModules = [
                .init(path: "A", dependencies: ["main": ["B", "C"]]),
                .init(path: "B", dependencies: ["main": ["C"]]),
                .init(path: "C", dependencies: [:])
            ]

            XCTAssertEqual(
                try builder.makeError(),
                StackGenError.Kind.transitiveDependencyDuplication("A", "C")
            )
        }
    }

    func testModulesDuplication() {
        do {
            let builder = Builder()
            builder.firstPartyModules = [
                .init(path: "A", dependencies: [:]),
                .init(path: "A", dependencies: [:]),
            ]

            XCTAssertEqual(
                try builder.makeError(),
                StackGenError.Kind.foundDuplicatedModules(["A"])
            )
        }

        do {
            let builder = Builder()
            builder.firstPartyModules = [
                .init(path: "A", dependencies: [:]),
            ]
            builder.thirdPartyModules = ["A"]

            XCTAssertEqual(
                try builder.makeError(),
                StackGenError.Kind.foundDuplicatedModules(["A"])
            )
        }
    }

    func testDependenciesDuplication() {
        do {
            let builder = Builder()
            builder.firstPartyModules = [
                .init(path: "A", dependencies: ["main": ["B", "B", "C", "C"]]),
                .init(path: "B", dependencies: [:]),
            ]

            XCTAssertEqual(
                try builder.makeError(),
                StackGenError.Kind.foundDuplicatedDependencies(["B", "C"], "A")
            )
        }
    }

    func testDependencyCycle() {
        do {
            let builder = Builder()
            builder.firstPartyModules = [
                .init(path: "A", dependencies: ["main": ["A"]]),
            ]

            XCTAssertEqual(
                try builder.makeError(),
                StackGenError.Kind.foundDependencyCycle(["A", "A"])
            )
        }

        do {
            let builder = Builder()
            builder.firstPartyModules = [
                .init(path: "A", dependencies: ["test": ["A"]]),
            ]

            XCTAssertEqual(
                try builder.makeError(),
                nil
            )
        }

        do {
            let builder = Builder()
            builder.firstPartyModules = [
                .init(path: "A", dependencies: ["main": ["B"]]),
                .init(path: "B", dependencies: ["main": ["C"]]),
                .init(path: "C", dependencies: ["main": ["A"]]),
            ]

            XCTAssertEqual(
                try builder.makeError(),
                StackGenError.Kind.foundDependencyCycle(["A", "B", "C", "A"])
            )
        }

        do {
            let builder = Builder()
            builder.firstPartyModules = [
                .init(path: "A", dependencies: ["main": ["B"]]),
                .init(path: "B", dependencies: ["main": ["C"]]),
                .init(path: "C", dependencies: ["test": ["A"]]),
            ]

            XCTAssertEqual(
                try builder.makeError(),
                nil
            )
        }
    }
}

private class Builder {
    var firstPartyModules: [FirstPartyModule.Input] = []
    var thirdPartyModules: [String] = []

    init() { }

    func makeError() throws -> StackGenError.Kind? {
        let sut = try makeModuleResolver()
        let expression = { try sut.resolve() }
        return Result(catching: expression).error
    }

    func makeModuleResolver() throws -> ModuleResolver {
        let env = Env()

        let stackGenFile = StackGenFile(
            options: .init(),
            global: [:],
            firstPartyModules: firstPartyModules,
            thirdPartyModules: thirdPartyModules.map {
                ThirdPartyModule.Input.init(.init(name: $0), [:])
            },
            availableTemplateGroups: [:]
        )
        return try ModuleResolver(stackGenFile, env)
    }
}

private extension Result {
    var error: StackGenError.Kind? {
        do {
            _ = try self.get()
            return nil
        } catch {
            return (error as? StackGenError)?.kind
        }
    }
}
