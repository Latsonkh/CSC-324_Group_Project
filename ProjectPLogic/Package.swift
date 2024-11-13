// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// disable LLM.swift dependency on linux
#if !os(Linux)
let packageDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/eastriverlee/LLM.swift.git", branch: "pinned")
]
let targetDependencies: [Target.Dependency] = [
    .product(name: "LLM", package: "llm.swift")
]
#else
let packageDependencies: [Package.Dependency] = []
let targetDependencies: [Target.Dependency] = []
#endif

let package = Package(
    name: "ProjectPLogic",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(
            name: "ProjectPLogic",
            targets: ["ProjectPLogic"]
        ),
    ],
    dependencies: packageDependencies,
    targets: [
        .target(
            name: "ProjectPLogic",
            dependencies: targetDependencies
        ),
        .testTarget(
            name: "ProjectPLogicTests",
            dependencies: ["ProjectPLogic"]
        ),
    ]
)
