// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "StackGen",
    platforms: [.macOS(.v10_14)],
    products: [
        .executable(name: "stackgen", targets: ["StackGen"]),
        .library(name: "StackGenKit", targets: ["StackGenKit"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/acecilia/Stencil.git",
            .revision("b43f9dd5151f92625c51c901193549e5d0030244")
            // Using a fork until https://github.com/stencilproject/Stencil/pull/289 is merged and released
        ),
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/jpsim/Yams.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/mxcl/Path.swift.git", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/jakeheis/SwiftCLI.git", .upToNextMajor(from: "6.0.1")),
        .package(url: "https://github.com/acecilia/StringCodable.git", .revision("b7d46cd32791753df1fe13b0b6ecdd9a19fbabcc")),
        .package(url: "https://github.com/acecilia/RuntimeTestCaseSwift.git", .revision("e2c6ed3fc47279c85c5e5750a600e5e9ab86a0c9")),
        .package(url: "https://github.com/acecilia/Compose.git", .upToNextMajor(from: "0.0.4")),
        // .package(path: "../RuntimeTestCaseSwift"),
    ],
    targets: [
        // ################################
        // Main
        // ################################

        .target(
            name: "StackGen",
            dependencies: ["StackGenCLI"]
        ),
        .target(
            name: "StackGenCLI",
            dependencies: [
                "StackGenKit",
                "SwiftCLI",
            ]
        ),
        .target(
            name: "StackGenKit",
            dependencies: [
                "Stencil",
                "Yams",
                "Path",
                "StringCodable",
                "SwiftCLI",
                "Compose",
                "SwiftTemplateEngine",
            ]
        ),
        .testTarget(
            name: "StackGenTests",
            dependencies: [
                "StackGenCLI",
                "RuntimeTestCase",
            ]
        ),

        // ################################
        // Sourcery
        // ################################

        .target(
            name: "SourceryUtils",
            dependencies: ["PathKit"],
            path: "submodules/sourcery/Sources/SourceryUtils"
        ),
        .target(
            name: "SwiftTemplateEngine",
            dependencies: ["SourceryUtils"],
            path: "submodules/sourcery/Sources/SwiftTemplateEngine"
        ),

        // ################################
        // Swift template
        // ################################

        .target(
            name: "SwiftTemplateRuntime",
            dependencies: [
                "StackGenKit",
            ]
        ),
    ]
)
