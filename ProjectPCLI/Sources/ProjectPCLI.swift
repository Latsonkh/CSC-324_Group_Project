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
// //        let question = "A person walks in the following pattern: 3.1 km north, then 2.4 km west, and finally 5.2km south. In what direction would a bird fly in a straight line from the same starting point to the same final point?"
// //
// //        await LLMHandler.shared.classify(problem: question)
// //
// //        print("========")

        let exampleSolution = try await exampleDistanceProblem()

        print("steps:")
        print("1. classify problem:", exampleSolution.classification.description)
        print("2. set up inputs:\n", exampleSolution.input.variables.map {
            "\($0.name) = \($0.value)"
        }.joined(separator: "\n "))
        for (idx, step) in exampleSolution.output.steps.enumerated() {
            print("\(idx + 3).", step.toString())
        }
        print("----")
        print("answer:", exampleSolution.output.answer)
    }
}
