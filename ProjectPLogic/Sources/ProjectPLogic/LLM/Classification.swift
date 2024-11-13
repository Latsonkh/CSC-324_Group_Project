//
//  Classification.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/13/24.
//

public enum Classification {
    case twoPointsDistance
}

extension Classification {
    public var description: String {
        switch self {
            case .twoPointsDistance: "Distance Between Two Points"
        }
    }

    public func getPrompt() -> String {
        switch self {
            case .twoPointsDistance: DistanceProblem.prompt
        }
    }

    public func parseProblem(llmOutput: String) -> Problem {
        switch self {
            case .twoPointsDistance: DistanceProblem.from(llmOutput: llmOutput)
        }
    }
}
