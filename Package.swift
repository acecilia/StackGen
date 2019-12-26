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
            .revision("6f6a983a938b0d37e3fe00a723043c56026116fc")
            // Using a fork until https://github.com/stencilproject/Stencil/pull/289 is merged and released
        ),
        .package(url: "https://github.com/jpsim/Yams.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/mxcl/Path.swift.git", .upToNextMajor(from: "1.0.0-alpha.3")),
        .package(url: "https://github.com/jakeheis/SwiftCLI.git", .upToNextMajor(from: "5.3.3")),
        // The version of xcodeproj is tight with the one used by XcodeGen
        .package(url: "https://github.com/tuist/xcodeproj.git", .exact("7.1.0")),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", .upToNextMajor(from: "2.10.1")),
        .package(url: "https://github.com/Flight-School/AnyCodable.git", .upToNextMajor(from: "0.2.3")),
        .package(url: "https://github.com/mxcl/Version.git", .upToNextMajor(from: "1.2.0")),
        .package(
            url: "https://github.com/acecilia/Carthage.git",
            .revision("aebb5b2dda0fcb489f2baa3605aa79b2d742af67") // Latest on master at the time of writing
            // Using a fork until https://github.com/Carthage/Carthage/pull/2910 is merged and released
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
                "XcodeProj",
                "XcodeGenKit",
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
