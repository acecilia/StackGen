import Foundation
import Path

/// A protocol to limit the exposed API
public protocol WriterAppendProtocol {
    func append(writeOperation: WriteOperation)
}

/// A protocol to limit the exposed API
public protocol WriterGenerateProtocol: WriterAppendProtocol {
    func cleanAll() throws
    func writeAll() throws
}

public protocol WriterProtocol: WriterGenerateProtocol { }

/// The service used to write files to disk
public class Writer: WriterProtocol {
    var dryRun: Bool
    private let env: Env
    private var writeOperations: [WriteOperation] = []

    public init(_ env: Env, dryRun: Bool = false) {
        self.env = env
        self.dryRun = dryRun
    }
    
    public func append(writeOperation: WriteOperation) {
        writeOperations.append(writeOperation)
    }

    public func cleanAll() throws {
        guard !dryRun else { return }

        for operation in writeOperations {
            try operation.path.delete()
        }
    }

    public func writeAll() throws {
        guard !dryRun else { return }

        for operation in writeOperations {
            env.reporter.info(.sparkles, "writing \(operation.path.relative(to: env.cwd))")

            try operation.path.parent.mkdir(.p)

            let content: String
            switch operation.mergeBehaviour {
            case .replace:
                content = operation.content

            case .append:
                guard let existingContent = try String(operation.path) else {
                    content = operation.content
                    break
                }

                content = existingContent
                    .appending("\n")
                    .appending(operation.content)
            }

            if content.isEmpty {
                try operation.path.delete()
            } else {
                try content.write(to: operation.path)
                if let posixPermissions = operation.posixPermissions {
                    try FileManager.default.setAttributes(
                        [.posixPermissions: posixPermissions],
                        ofItemAtPath: operation.path.string
                    )
                }
            }
        }
    }
}

public struct WriteOperation {
    let content: String
    let path: Path
    let posixPermissions: Any?
    let mergeBehaviour: MergeBehaviour
}

private extension String {
    init?(_ path: Path) throws {
        guard path.exists else {
            return nil
        }

        let existingContent = try String(contentsOf: path)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !existingContent.isEmpty else {
            return nil
        }

        self = existingContent
    }
}

