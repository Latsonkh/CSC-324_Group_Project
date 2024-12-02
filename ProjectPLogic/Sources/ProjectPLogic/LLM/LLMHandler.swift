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

    func askLLM(question: String) async throws -> String {
//        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
//            fatalError("missing api key")
//        }
        let apiKey = "AIzaSyDfx4vAJZlFPm8ysriU2CV8pcbUg4mhMZI"

        let model = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: apiKey
        )
        
        let response = try await model.generateContent(question)
        
        return response.text ?? ""
    }

    // Classify a problem as one of our pre-defined classifications
    public func classify(problem: String) async throws -> Classification {
        let prompt = """
        Respond with only one of the following classifications:
        \(Classification.allCases.enumerated().map { idx, item in
            "- \(item.description)"
        }.joined(separator: "\n"))
        
        Respond "None" if no classifications fit the problem. 
        Do not solve the problem. Do not explain the problem.
        
        \(problem)
        """

        let answer = try await askLLM(question: prompt).trimmingCharacters(in: .whitespacesAndNewlines)

        print("answer:", answer)

        guard let classification = Classification.fromString(name: answer) else {
            throw LLMError.classificationFailed
        }

        return classification
    }

    public func classifyAndPrompt(problem: String) async throws -> (Classification, String) {
        let classification = try await classify(problem: problem)

        let prompt = classification.getPrompt() + "\n\n" + problem

        let answer = try await askLLM(question: prompt)

        return (classification, answer)
    }
}

enum LLMError: Error {
    case classificationFailed
}

#endif
