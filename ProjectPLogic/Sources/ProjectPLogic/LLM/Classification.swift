//
//  Classification.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/13/24.
//

public enum Classification: Sendable {
    case twoPointsDistance
    case addVectors
    case posVelTime
}

extension Classification {
    public var description: String {
        switch self {
            case .twoPointsDistance: "Distance Between Two Points"
            case .addVectors: "Adding Vectors to Derive Final Position"
            case .posVelTime: "Find a Position given a Vector and a Quantity of Time"
        }
    }

    public func getPrompt() -> String {
        switch self {
            case .twoPointsDistance: DistanceProblem.prompt
            case .addVectors: PositionProblem.prompt
            case .posVelTime: PositionVelTimeProblem.prompt
        }
    }

    public func parseProblem(llmOutput: String) -> Problem {
        switch self {
            case .twoPointsDistance: DistanceProblem.from(llmOutput: llmOutput)
            case .addVectors: PositionProblem.from(llmOutput: llmOutput)
            case .posVelTime: PositionVelTimeProblem.from(llmOutput: llmOutput)
        }
    }
}
