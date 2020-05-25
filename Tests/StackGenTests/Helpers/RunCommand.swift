import Foundation

// From https://stackoverflow.com/a/29519615

@discardableResult
func runCommand(_ cmd: String) -> (output: [String], error: [String], exitCode: Int32) {
    // For problems with shell environment when running non-interactive shells see:
    // * https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout
    // * https://docs.brew.sh/FAQ#my-mac-apps-dont-find-usrlocalbin-utilities
    let result = runCommand(
        cmd: "/bin/zsh",
        args: "-c",
        """
        eval $(/usr/local/bin/brew shellenv) # Allow access to brew installed binaries in this shell
        cd \(FileManager.default.currentDirectoryPath)
        \(cmd)
        """
    )
    return result
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
