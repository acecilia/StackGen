// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "{{global.root.basename}}",
    platforms: [.macOS(.v10_14)],
    products: [
        .executable(name: "{{global.root.basename}}", targets: ["{{global.root.basename}}"]),
        .library(name: "{{global.root.basename}}Kit", targets: ["{{global.root.basename}}Kit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI.git", .upToNextMajor(from: "6.0.1")),
    ],
    targets: [
        .target(
            name: "{{global.root.basename}}",
            dependencies: [
                "{{global.root.basename}}CLI",
            ]
        ),
        .target(
            name: "{{global.root.basename}}CLI",
            dependencies: [
                "{{global.root.basename}}Kit",
                "SwiftCLI",
            ]
        ),
        .target(
            name: "{{global.root.basename}}Kit",
            dependencies: [
            ]
        ),
        .testTarget(
            name: "{{global.root.basename}}Tests",
            dependencies: [
                "{{global.root.basename}}CLI"
            ]
        ),
    ]
)
