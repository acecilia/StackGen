// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "BuildSystemGenerator",
    platforms: [.macOS(.v10_14)],
    products: [
        .executable(name: "bsg", targets: ["BuildSystemGenerator"]),
        .library(name: "BuildSystemGeneratorKit", targets: ["BuildSystemGeneratorKit"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/acecilia/Stencil.git",
            .revision("b43f9dd5151f92625c51c901193549e5d0030244")
            // Using a fork until https://github.com/stencilproject/Stencil/pull/289 is merged and released
        ),
        .package(url: "https://github.com/jpsim/Yams.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/mxcl/Path.swift.git", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/jakeheis/SwiftCLI.git", .upToNextMajor(from: "6.0.1")),
        .package(url: "https://github.com/mxcl/Version.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/acecilia/StringCodable.git", .revision("b7d46cd32791753df1fe13b0b6ecdd9a19fbabcc")),
        .package(url: "https://github.com/acecilia/RuntimeTestCaseSwift", .revision("e2c6ed3fc47279c85c5e5750a600e5e9ab86a0c9")),
        .package(url: "https://github.com/tattn/MoreCodable", .upToNextMajor(from: "1.3.0")),
        // .package(path: "../RuntimeTestCaseSwift"),
    ],
    targets: [
        .target(
            name: "BuildSystemGenerator",
            dependencies: ["BuildSystemGeneratorCLI"]
        ),
        .target(
            name: "BuildSystemGeneratorCLI",
            dependencies: [
                "BuildSystemGeneratorKit",
                "SwiftCLI",
            ]
        ),
        .target(
            name: "BuildSystemGeneratorKit",
            dependencies: [
                "Stencil",
                "Yams",
                "Path",
                "Version",
                "StringCodable",
                "SwiftCLI",
                "MoreCodable"
            ]
        ),
        .testTarget(
            name: "BuildSystemGeneratorTests",
            dependencies: [
                "BuildSystemGeneratorCLI",
                "RuntimeTestCase",
            ]
        )
    ]
)
