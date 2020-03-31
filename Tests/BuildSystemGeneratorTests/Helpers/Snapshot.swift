import XCTest
import Path

enum Snapshot {
    static var recording = false
}

extension XCTestCase {
    func assert(fixure: Path, equals path: Path, file: StaticString = #file, line: UInt = #line) {
        if Snapshot.recording {
            try! fixure.parent.mkdir(.p)
            try! path.copy(to: fixure)
        } else {
            assert(reference: fixure, equals: path, file: file, line: line)
        }
    }

    func assert(reference: Path, equals path: Path, exclude: [String] = [], file: StaticString = #file, line: UInt = #line) {
        let diffCommand = (["diff -rN --exclude=.DS_Store --exclude=Carthage"] + exclude.map { "--exclude=\($0)"}).joined(separator: " ")
        let result = runCommand("\(diffCommand) \(reference.string) \(path.string)")
        let output = result.output.joined(separator: "\n")

        var openDiffCommand: [String] = []
        if result.exitCode != 0 {
            let resultPerFile = output
                .components(separatedBy: diffCommand)
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { $0.isEmpty == false }

            for fileResult in resultPerFile {
                let files = fileResult.components(separatedBy: .newlines).first!.components(separatedBy: .whitespaces)
                let filePathLeft = files[0]
                let filePathRight = files[1]
                // Command to open the FileMerge app fast with all the differences
                openDiffCommand.append("(OpenDiff \(filePathLeft) \(filePathRight) &)")
            }
        }
        let errorMessage = """
        To see the differences open the following command in a terminal:
        \(openDiffCommand.joined(separator: ";"))

        Diff output:
        \(output)
        """
        XCTAssertEqual(result.exitCode, 0, errorMessage, file: file, line: line)
    }
}
