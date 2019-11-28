import Foundation
import Path

public protocol OutputPathInterface: CaseIterable {
    associatedtype T
    func path(for object: T) -> Path
}

public extension OutputPathInterface {
    func relativePath(for object: T) -> String {
        return path(for: object).relative(to: cwd)
    }

    func absolutePath(for object: T) -> String {
        return path(for: object).string
    }

    static func cleanAll(for object: T) throws {
        var removedFiles: [Path] = []

        let filesToRemove = Self.allCases.map { $0.path(for: object) }
        for fileToRemove in filesToRemove where fileToRemove.exists {
            try fileToRemove.delete()
            removedFiles.append(fileToRemove)
        }

        if removedFiles.isEmpty == false {
            let removedFilesList = removedFiles.map { $0.relative(to: cwd) }.joined(separator: ", ")
            Reporter.info("removed files: \(removedFilesList)")
        }
    }
}
