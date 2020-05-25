// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "{{env.root.basename}}",
    platforms: [.macOS(.v10_14)],
    products: [
        .executable(name: "{{env.root.basename}}", targets: ["{{env.root.basename}}"]),
        .library(name: "{{env.root.basename}}Kit", targets: ["{{env.root.basename}}Kit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI.git", .upToNextMajor(from: "6.0.1")),
    ],
    targets: [
        .target(
            name: "{{env.root.basename}}",
            dependencies: [
                "{{env.root.basename}}CLI",
            ]
        ),
        .target(
            name: "{{env.root.basename}}CLI",
            dependencies: [
                "{{env.root.basename}}Kit",
                "SwiftCLI",
            ]
        ),
        .target(
            name: "{{env.root.basename}}Kit",
            dependencies: [
            ]
        ),
        .testTarget(
            name: "{{env.root.basename}}Tests",
            dependencies: [
                "{{env.root.basename}}CLI"
            ]
        ),
    ]
)
