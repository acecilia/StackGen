import Foundation
import Path

public protocol OutputPathInterface: CaseIterable {
    func path(for module: Module) -> Path
}

public extension OutputPathInterface {
    func relativePath(for module: Module) -> String {
        return path(for: module).relative(to: Options.rootPath)
    }

    func absolutePath(for module: Module) -> String {
        return path(for: module).string
    }

    static func cleanAll(for module: Module) throws {
        var removedFiles: [Path] = []

        let filesToRemove = Self.allCases.map { $0.path(for: module) }
        for fileToRemove in filesToRemove where fileToRemove.exists {
            try fileToRemove.delete()
            removedFiles.append(fileToRemove)
        }

        if removedFiles.isEmpty == false {
            let removedFilesList = removedFiles.map { $0.relative(to: Options.rootPath) }.joined(separator: ", ")
            Reporter.print("Removed files: \(removedFilesList)")
        }
    }
}
