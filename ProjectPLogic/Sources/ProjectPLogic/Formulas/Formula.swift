//
//  Formula.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/13/24.
//

public protocol Formula: Sendable {
    associatedtype Input
    associatedtype Output

    var input: Input { get }

    var description: String { get }

    func evaluate() -> Output?
}
