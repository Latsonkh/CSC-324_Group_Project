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
        let problem = """
A person walks in the following pattern: 3.1 km north, then 2.4 km west, and finally 5.2km south. How far could a bird fly in a straight line from the same starting point to the same final point?
"""
        let (_, answer) = try await LLMHandler.shared.classifyAndPrompt(problem: problem)
        print(answer)
    }
}
