//
//  Formula.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/13/24.
//

public protocol Formula: Sendable, Codable {
    associatedtype Input
    associatedtype Output

    var input: Input { get }

    var description: String { get }

    func evaluate() -> Output?
}

public enum FormulaInstance: Sendable, Codable {
    case distance(DistanceFormula)
    case addVectors(AddVectorsFormula)
    case DGivenVAT(DGivenVATFormula)
}

extension FormulaInstance {
    var description: String {
        switch self {
            case .distance(let f): f.description
            case .addVectors(let f): f.description
            case .DGivenVAT(let f): f.description
        }
    }
}
