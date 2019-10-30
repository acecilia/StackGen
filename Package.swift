// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SwiftBuildSystemGenerator",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "swiftbuildsystemgenerator", targets: ["SwiftBuildSystemGenerator"]),
        .library(name: "SwiftBuildSystemGeneratorKit", targets: ["SwiftBuildSystemGeneratorKit"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/stencilproject/Stencil.git",
            .revision("e516ca9389b64da70b71a461925bbca66f65fe61") // Latest on master at the time of writing
        ),
        .package(url: "https://github.com/kylef/PathKit", .upToNextMajor(from: "1.0.0")), // This should not be needed here, but without it SPM can not properly resolve depndencies...
        .package(url: "https://github.com/jpsim/Yams.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/mxcl/Path.swift.git", .upToNextMajor(from: "1.0.0-alpha.3")),
        .package(url: "https://github.com/jakeheis/SwiftCLI", .upToNextMajor(from: "5.3.3")),
        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "7.2.0")),
        .package(url: "https://github.com/tuist/shell.git", .upToNextMajor(from: "2.0.1")),
    ],
    targets: [
        .target(
            name: "SwiftBuildSystemGenerator",
            dependencies: ["SwiftBuildSystemGeneratorCLI"]
        ),
        .target(
            name: "SwiftBuildSystemGeneratorCLI",
            dependencies: [
                "SwiftBuildSystemGeneratorKit",
                "SwiftCLI",
            ]
        ),
        .target(
            name: "SwiftBuildSystemGeneratorKit",
            dependencies: [
                "Stencil",
                "Yams",
                "Path",
                "XcodeProj",
                "PathKit",
                "Shell",
            ]
        ),
        .testTarget(
            name: "SwiftBuildSystemGeneratorKitTests",
            dependencies: ["SwiftBuildSystemGeneratorKit"]
        ),
    ]
)
