// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import ProjectPLogic

@main
struct ProjectPCLI: AsyncParsableCommand {
    mutating func run() async throws {
        await testLLM()
    }
}
