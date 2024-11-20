//
//  Output.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

public struct Output: Sendable {
    public let steps: [Step]
    public let answer: OutputValue
}

public enum OutputValue: Sendable {
    case value(Value)
    case vector(Vector)
}