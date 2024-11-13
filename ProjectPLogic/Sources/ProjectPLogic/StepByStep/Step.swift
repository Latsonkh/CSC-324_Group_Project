//
//  Step.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

public enum Step {
    case applyFormula(any Formula)
}

extension Step {
    public func toString() -> String {
        switch self {
            case .applyFormula(let formula):
                return "apply formula: \(formula)"
        }
    }
}
