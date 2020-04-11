// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "{{global.rootBasename}}",
    platforms: [.macOS(.v10_14)],
    products: [
        .executable(name: "{{global.rootBasename}}", targets: ["{{global.rootBasename}}"]),
        .library(name: "{{global.rootBasename}}Kit", targets: ["{{global.rootBasename}}Kit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI.git", .upToNextMajor(from: "6.0.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "{{global.rootBasename}}",
            dependencies: [
                "{{global.rootBasename}}CLI",
            ]
        ),
        .target(
            name: "{{global.rootBasename}}CLI",
            dependencies: [
                "{{global.rootBasename}}Kit",
                "SwiftCLI",
            ]
        ),
        .target(
            name: "{{global.rootBasename}}Kit",
            dependencies: [
            ]
        ),
        .testTarget(
            name: "{{global.rootBasename}}Tests",
            dependencies: [
                "{{global.rootBasename}}CLI"
            ]
        ),
    ]
)
