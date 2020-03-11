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
            let result = runCommand(cmd: "/usr/bin/diff", args: "-rN", "--exclude=.DS_Store", fixture.string, testOutput.string)
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

private func runCommand(cmd: String, args: String...) -> (output: [String], error: [String], exitCode: Int32) {
    var output : [String] = []
    var error : [String] = []

    let task = Process()
    task.launchPath = cmd
    task.arguments = args

    let outpipe = Pipe()
    task.standardOutput = outpipe
    let errpipe = Pipe()
    task.standardError = errpipe

    task.launch()

    let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
    if var string = String(data: outdata, encoding: .utf8) {
        string = string.trimmingCharacters(in: .newlines)
        output = string.components(separatedBy: "\n")
    }

    let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
    if var string = String(data: errdata, encoding: .utf8) {
        string = string.trimmingCharacters(in: .newlines)
        error = string.components(separatedBy: "\n")
    }

    task.waitUntilExit()
    let status = task.terminationStatus

    return (output, error, status)
}
