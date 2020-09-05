import Foundation
import Yams
import Path

/// The action corresponting to the `lint` subcommand
public class LintAction: Action {
    private var env: Env

    public init(_ env: Env) {
        self.env = env
    }

    public func execute() throws {
        env.reporter.info(.broom, "linting")

        guard let stackGenFile = try StackGenFile.resolve(&env) else {
            fatalError()
        }

        let encoder = YAMLEncoder()
        encoder.options = .init(
            canonical: false,
            indent: 20,
            width: 200
        )
        let encoded = try encoder.encode(stackGenFile)
        try encoded.write(to: env.cwd/"2\(Constant.stackGenFileName)")
    }
}
