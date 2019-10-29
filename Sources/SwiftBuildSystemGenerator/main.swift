import SwiftBuildSystemGeneratorKit
import Path

let rootPath = Path.cwd/"Examples"

let fileIterator = FileIterator()
let modules = try fileIterator.start(rootPath)

let generators: [FileGeneratorInterface] = [
    XcodegenGenerator(modules)
]

for generator in generators {
    try generator.generate()
}

// Clean
for generator in generators {
    let outputFileName = type(of: generator).outputFileName
    let filesToRemove = rootPath.find().type(.file).filter { $0.basename() == outputFileName }
    for fileToRemove in filesToRemove {
        try fileToRemove.delete()
    }
}


