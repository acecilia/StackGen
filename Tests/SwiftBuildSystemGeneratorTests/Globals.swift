import Foundation
import SwiftBuildSystemGeneratorCLI
import Path

let rootPath = Path(#file)!/".."/".."/".."

let examplesPath = rootPath/"Examples"
let fixturesPath = rootPath/"Fixtures"

func tmp() throws -> Path {
    return try Path(uniqueTemporaryPathKit().string)!
}

func functionName(_ methodSignature: String) -> String {
    return methodSignature
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")

}

let generateCommandArgs = [GenerateCommand.name, "-x", "-t", "\((rootPath/"Templates").string)"]

