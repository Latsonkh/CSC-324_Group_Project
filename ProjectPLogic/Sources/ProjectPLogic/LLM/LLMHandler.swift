//
//  LLM.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

@preconcurrency import LLM

public actor LLMHandler {
    public static let shared = LLMHandler()

    func askLLM(question: String) async -> String {
        let systemPrompt = "You are a an expert Physics problem solver."
        let bot = try! await LLM(from: HuggingFaceModel("TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF", .Q2_K, template: .chatML(systemPrompt)))
        let question = bot.preprocess(question, [])
        return await bot.getCompletion(from: question)
    }

    public func solve(problem: String) async throws -> Solution? {
        guard let classification = await classify(problem: problem) else {
            return nil
        }
        return try await solve(problem: problem, classification: classification)
    }

    public func classify(problem: String) async -> Classification? {
        let prompt = """
Give a short category description that indicates the type of the following Physics problem.

Physics problem:
\(problem)
"""

        let answer = await askLLM(question: prompt)
        print("=============")
        print(answer)

        return Classification.twoPointsDistance
    }

    public func solve(problem: String, classification: Classification) async throws -> Solution? {
        let prompt = classification.getPrompt() + "\n\nPhysics problem:\n" + problem

        let answer = await askLLM(question: prompt)

        let problem = classification.parseProblem(llmOutput: answer)

        let output = try problem.solve()

        return Solution(
            classification: .twoPointsDistance,
            input: problem.input,
            output: output
        )
    }
}
