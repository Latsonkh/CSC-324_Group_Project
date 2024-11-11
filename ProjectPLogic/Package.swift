// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProjectPLogic",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(
            name: "ProjectPLogic",
            targets: ["ProjectPLogic"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/eastriverlee/LLM.swift.git", branch: "pinned")
    ],
    targets: [
        .target(
            name: "ProjectPLogic",
            dependencies: [
                .product(name: "LLM", package: "llm.swift")
            ]
        ),
        .testTarget(
            name: "ProjectPLogicTests",
            dependencies: ["ProjectPLogic"]
        ),
    ]
)
