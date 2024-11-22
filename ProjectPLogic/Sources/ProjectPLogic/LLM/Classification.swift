//
//  Classification.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/13/24.
//

public enum Classification: Sendable, CaseIterable {
    case twoPointsDistance
    case addVectors
}

extension Classification {
    public var description: String {
        switch self {
            case .twoPointsDistance: "Distance Between Two Points"
            case .addVectors: "Adding Vectors to Derive Final Position"
        }
    }

    public func getPrompt() -> String {
        switch self {
            case .twoPointsDistance: DistanceProblem.prompt
            case .addVectors: PositionProblem.prompt
        }
    }

    public func parseProblem(llmOutput: String) -> Problem {
        switch self {
            case .twoPointsDistance: DistanceProblem.from(llmOutput: llmOutput)
            case .addVectors: PositionProblem.from(llmOutput: llmOutput)
        }
    }
    
    public static func fromString(name: String) -> Self {
        switch name {
            case "Distance Between Two Points": .twoPointsDistance
            default: .twoPointsDistance // TODO: Should be error
        }
    }
}
