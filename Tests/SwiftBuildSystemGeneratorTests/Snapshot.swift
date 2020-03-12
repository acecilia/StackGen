import XCTest
import Path

enum Snapshot {
    static var recording = false
}

extension XCTestCase {
    func assert(fixture: Path, equals testOutput: Path, file: StaticString = #file, line: UInt = #line) {
        if Snapshot.recording {
            try! fixture.parent.mkdir(.p)
            try! testOutput.copy(to: fixture)
        } else {
            let result = runCommand("diff -rN --exclude=.DS_Store \(fixture.string) \(testOutput.string)")
            let output = result.output.joined(separator: "\n")

            var diffCommand: [String] = []
            if result.exitCode != 0 {
                let resultPerFile = output.components(separatedBy: "diff -rN --exclude=.DS_Store ").filter { $0.isEmpty == false }
                for fileResult in resultPerFile {
                    let files = fileResult.components(separatedBy: .newlines).first!.components(separatedBy: .whitespaces)
                    let filePathLeft = files[0]
                    let filePathRight = files[1]
                    // Command to open the FileMerge app fast with all the differences
                    diffCommand.append("(OpenDiff \(filePathLeft) \(filePathRight) &)")
                }
            }
            XCTAssertEqual(result.exitCode, 0, "\n\n\n\(diffCommand.joined())\n\n\n\(output)", file: file, line: line)
        }
    }
}
