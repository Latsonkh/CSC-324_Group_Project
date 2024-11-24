//
//  ProjectPCLI.swift
//  ProjectPCLI
//
//  Created by Caelan on 11/11/24.
//

import ArgumentParser
import ProjectPLogic

@main
struct ProjectPCLI: AsyncParsableCommand {
    mutating func run() async throws {
//        let question = "A person walks in the following pattern: 3.1 km north, then 2.4 km west, and finally 5.2 km south. In what direction would a bird fly in a straight line from the same starting point to the same final point?"

        let exampleSolution = try await exampleDistanceProblem()

        print("steps:")
        for (idx, step) in exampleSolution.steps.enumerated() {
            print("\(idx + 1).", step.toString())
        }
        print("----")
        print("answer:", exampleSolution.answer)
    }
}
