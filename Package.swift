// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SwiftBuildSystemGenerator",
    platforms: [.macOS(.v10_14)],
    products: [
        .executable(name: "swiftbuildsystemgenerator", targets: ["SwiftBuildSystemGenerator"]),
        .library(name: "SwiftBuildSystemGeneratorKit", targets: ["SwiftBuildSystemGeneratorKit"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/acecilia/Stencil.git",
            .revision("1c4eab02c5d2c4ba64418dd23bd0801b8cd4eb2d")
            // Using a fork until https://github.com/stencilproject/Stencil/pull/289 is merged and released
        ),
        .package(url: "https://github.com/jpsim/Yams.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/mxcl/Path.swift.git", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/jakeheis/SwiftCLI.git", .upToNextMajor(from: "6.0.1")),
        // The version of xcodeproj is tight with the one used by XcodeGen
        // .package(url: "https://github.com/tuist/xcodeproj.git", .exact("7.1.0")),
        // .package(url: "https://github.com/yonaskolb/XcodeGen.git", .upToNextMajor(from: "2.10.1")),
        .package(url: "https://github.com/Flight-School/AnyCodable.git", .upToNextMajor(from: "0.2.3")),
        .package(url: "https://github.com/mxcl/Version.git", .upToNextMajor(from: "2.0.0")),
        .package(
            url: "https://github.com/Carthage/Carthage.git",
            .revision("de66acf88f32ace83fe99b04fd14565290711ea9") // Latest on master at the time of writing
            // until https://github.com/Carthage/Carthage/pull/2910 is released
        ),
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
                // "XcodeProj",
                // "XcodeGenKit",
                "AnyCodable",
                "Version",
                "CarthageKit",
                "XCDBLD",
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
