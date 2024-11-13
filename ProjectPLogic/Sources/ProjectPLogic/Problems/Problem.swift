//
//  Problem.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

public protocol Problem: LLMParsable {
    var input: Input { get }

    func solve() throws(ProblemError) -> Output
}

public enum ProblemError: Error {
    case invalidInput
    case message(String)
}
