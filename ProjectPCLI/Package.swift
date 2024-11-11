// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProjectPCLI",
    platforms: [.macOS(.v13), .iOS(.v16)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(path: "../ProjectPLogic")
    ],
    targets: [
        .executableTarget(
            name: "ProjectPCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ProjectPLogic", package: "ProjectPLogic")
            ]
        ),
    ]
)
