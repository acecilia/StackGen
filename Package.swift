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
        .package(url: "https://github.com/Flight-School/AnyCodable.git", .upToNextMajor(from: "0.2.3")),
        .package(url: "https://github.com/mxcl/Version.git", .upToNextMajor(from: "2.0.0")),
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
                "AnyCodable",
                "Version",
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
