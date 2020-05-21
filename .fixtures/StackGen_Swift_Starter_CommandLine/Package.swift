// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "StackGen_Swift_Starter_CommandLine",
    platforms: [.macOS(.v10_14)],
    products: [
        .executable(name: "StackGen_Swift_Starter_CommandLine", targets: ["StackGen_Swift_Starter_CommandLine"]),
        .library(name: "StackGen_Swift_Starter_CommandLineKit", targets: ["StackGen_Swift_Starter_CommandLineKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI.git", .upToNextMajor(from: "6.0.1")),
    ],
    targets: [
        .target(
            name: "StackGen_Swift_Starter_CommandLine",
            dependencies: [
                "StackGen_Swift_Starter_CommandLineCLI",
            ]
        ),
        .target(
            name: "StackGen_Swift_Starter_CommandLineCLI",
            dependencies: [
                "StackGen_Swift_Starter_CommandLineKit",
                "SwiftCLI",
            ]
        ),
        .target(
            name: "StackGen_Swift_Starter_CommandLineKit",
            dependencies: [
            ]
        ),
        .testTarget(
            name: "StackGen_Swift_Starter_CommandLineTests",
            dependencies: [
                "StackGen_Swift_Starter_CommandLineCLI"
            ]
        ),
    ]
)
