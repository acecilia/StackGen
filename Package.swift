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
        // Need to specify pathKit here because otherwise SPM goes mad
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/groue/GRMustache.swift", .upToNextMajor(from: "4.0.1")),
        .package(url: "https://github.com/jpsim/Yams.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/mxcl/Path.swift.git", .upToNextMajor(from: "1.0.0-alpha.3")),
        .package(url: "https://github.com/jakeheis/SwiftCLI", .upToNextMajor(from: "5.3.3")),
        // The version of xcodeproj is tight with the one used by XcodeGen
        .package(url: "https://github.com/tuist/xcodeproj.git", .exact("7.1.0")),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", .upToNextMajor(from: "2.10.0")),
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
                "Mustache",
                "Yams",
                "Path",
                "XcodeProj",
                "XcodeGenKit",
            ]
        ),
        .testTarget(
            name: "SwiftBuildSystemGeneratorTests",
            dependencies: [
                "SwiftBuildSystemGeneratorCLI",
            ]
        )
    ]
)
