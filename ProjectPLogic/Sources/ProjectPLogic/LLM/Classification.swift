//
//  Classification.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/13/24.
//

public enum Classification: String, Sendable, CaseIterable {
    case twoPointsDistance = "Distance Between Two Points"
    case addVectors = "Adding Vectors to Derive Final Position"
}

extension Classification {
    public var description: String {
        rawValue
    }

    public func getPrompt() -> String {
        switch self {
            case .twoPointsDistance: DistanceProblem.prompt
            case .addVectors: PositionProblem.prompt
        }
    }

    public func parseProblem(llmOutput: String) -> Problem? {
        switch self {
            case .twoPointsDistance: DistanceProblem.from(llmOutput: llmOutput)
            case .addVectors: PositionProblem.from(llmOutput: llmOutput)
        }
    }
    
    public static func fromString(name: String) -> Self? {
        Self(rawValue: name)
    }
}
