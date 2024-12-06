//
//  Classification.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/13/24.
//

public enum Classification: String, Sendable, CaseIterable, Codable {
    case twoPointsDistance = "Distance Between Two Points"
    case addVectors = "Adding Vectors to Derive Final Position"
    case dGivenVAT = "Deriving a Distance Given a Starting Velocity, Constant Acceleration Vector, and Time"
}

extension Classification {
    static func getList() -> [String] {
        allCases.map(\.description)
    }
}

extension Classification {
    public var description: String {
        rawValue
    }

    public func getPrompt() -> String {
        switch self {
            case .twoPointsDistance: DistanceProblem.prompt
            case .addVectors: PositionProblem.prompt
            case .dGivenVAT: DGivenVATProblem.prompt
        }
    }

    public func parseProblem(llmOutput: String) -> Problem? {
        switch self {
            case .twoPointsDistance: DistanceProblem.from(llmOutput: llmOutput)
            case .addVectors: PositionProblem.from(llmOutput: llmOutput)
            case .dGivenVAT: DGivenVATProblem.from(llmOutput: llmOutput)
        }
    }
    
    public static func fromString(name: String) -> Self? {
        Self(rawValue: name)
    }
}
