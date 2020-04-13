// swift-tools-version:5.0

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
