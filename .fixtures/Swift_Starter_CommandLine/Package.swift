// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Swift_Starter_CommandLine",
    platforms: [.macOS(.v10_14)],
    products: [
        .executable(name: "Swift_Starter_CommandLine", targets: ["Swift_Starter_CommandLine"]),
        .library(name: "Swift_Starter_CommandLineKit", targets: ["Swift_Starter_CommandLineKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI.git", .upToNextMajor(from: "6.0.1")),
    ],
    targets: [
        .target(
            name: "Swift_Starter_CommandLine",
            dependencies: [
                "Swift_Starter_CommandLineCLI",
            ]
        ),
        .target(
            name: "Swift_Starter_CommandLineCLI",
            dependencies: [
                "Swift_Starter_CommandLineKit",
                "SwiftCLI",
            ]
        ),
        .target(
            name: "Swift_Starter_CommandLineKit",
            dependencies: [
            ]
        ),
        .testTarget(
            name: "Swift_Starter_CommandLineTests",
            dependencies: [
                "Swift_Starter_CommandLineCLI"
            ]
        ),
    ]
)
