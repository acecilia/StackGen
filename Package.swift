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
        .package(url: "https://github.com/stencilproject/Stencil.git", .exact("0.13.1")),
        .package(url: "https://github.com/jpsim/Yams.git", .exact("2.0.0")),
        .package(url: "https://github.com/mxcl/Path.swift.git", .exact("1.0.0-alpha.3"))
    ],
    targets: [
        .target(
            name: "SwiftBuildSystemGenerator",
            dependencies: ["SwiftBuildSystemGeneratorKit"]
        ),
        .target(
            name: "SwiftBuildSystemGeneratorKit",
            dependencies: [
                "Stencil",
                "Yams",
                "Path",
            ]
        ),
        .testTarget(
            name: "SwiftBuildSystemGeneratorKitTests",
            dependencies: ["SwiftBuildSystemGeneratorKit"]
        ),
    ]
)
