//
//  Step.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

public enum Step: Sendable {
    case classify(Classification)
    case setupInput(Input)
    case applyFormula(any Formula)
}

extension Step {
    public func toString() -> String {
        switch self {
            case .classify(let classification):
                return "Identify problem type:\n\(classification.description)"
            case .setupInput(let input):
                let inputs = input.variables.map {
                    "$\($0.name) = \($0.value)$"
                }.joined(separator: "\n")
                return "Set up inputs:\n\(inputs)"
            case .applyFormula(let formula):
                return "Apply formula: $$\(formula.description)$$"
        }
    }
}
