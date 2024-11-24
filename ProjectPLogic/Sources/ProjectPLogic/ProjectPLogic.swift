//
//  ProjectPLogic.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

#if !os(Linux)

enum SolveError: Error {
    case invalidLLMOutput
}

public func solve(problem: String) async throws -> Solution {
    let (classification, answer) = try await LLMHandler.shared.classifyAndPrompt(problem: problem)

    guard let problem = classification.parseProblem(llmOutput: answer) else {
        throw SolveError.invalidLLMOutput
    }
    let output = try problem.solve()

    return Solution(
        classification: classification,
        input: problem.input,
        output: output
    )
}

#endif

public func exampleDistanceProblem() async throws -> Solution {
    let input = Input(variables: [
        Variable(
            name: "p_1",
            value: Point(
                x: Value(value: 0, unit: .distance(.meter(.kilo))),
                y: Value(value: 0, unit: .distance(.meter(.kilo)))
            )!
        ),
        Variable(
            name: "p_2",
            value: Point(
                x: Value(value: -2.4, unit: .distance(.meter(.kilo))),
                y: Value(value: 3.1 - 5.2, unit: .distance(.meter(.kilo)))
            )!
        )
    ])

    let problemOutput = try DistanceProblem(input: input).solve()

    return Solution(
        classification: .twoPointsDistance,
        input: input,
        output: problemOutput
    )
}
