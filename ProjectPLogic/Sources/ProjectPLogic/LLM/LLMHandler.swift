//
//  LLM.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

#if !os(Linux)

import Foundation
@preconcurrency import GoogleGenerativeAI

public actor LLMHandler {
    public static let shared = LLMHandler()
    
    private let model = "TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF"

    func askLLM(question: String) async -> String {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            fatalError("missing api key")
        }

        let model = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: apiKey
        )
        
        let response = try! await model.generateContent(question)
        
        return response.text ?? ""
    }
    
    // Attempts to solve a problem. Returns null if classification is not identified.
    public func solve(problem: String) async throws -> Solution? {
        guard let classification = await classify(problem: problem) else {
            return nil
        }
        return try await solve(problem: problem, classification: classification)
    }
    
    // Classify a problem as one of our pre-defined classifications
    public func classify(problem: String) async -> Classification? {
        let prompt = """
            Respond with only one of the following classifications:
                \(Classification.allCases.enumerated().map { idx, item in
                    "\(item.description)"
                })
            Respond "None" if no classifications fit the problem. 
            Do not solving the problem. Do not explain the problem.
            
            \(problem)
        """
        let answer = await askLLM(question: prompt)
        
        print("===== LLM Output for classify() =====")
        print(answer)
        
        return Classification.fromString(name: answer)
    }
    
    
    // Solves a problem once classification has been acquired.
    private func solve(problem: String, classification: Classification) async throws -> Solution? {
        let prompt = classification.getPrompt() + "\n\n" + problem

        let answer = await askLLM(question: prompt)
        
        print("===== LLM Output for solve() =====")
        print(answer)

        let problem = classification.parseProblem(llmOutput: answer)

        let output = try problem.solve()

        return Solution(
            classification: classification,
            input: problem.input,
            output: output
        )
    }
}

#endif
