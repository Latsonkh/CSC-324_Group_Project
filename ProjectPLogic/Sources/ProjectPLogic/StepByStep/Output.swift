//
//  Output.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

public struct Output: Sendable, Codable {
    public let steps: [Step]
    public let answer: OutputValue
}

public enum OutputValue: Sendable, Codable {
    case value(Value)
    case vector(Vector)
}

extension OutputValue: CustomStringConvertible {
    public var description: String {
        switch self {
            case .value(let value):
                value.description
            case .vector(let vector):
                vector.description
        }
    }
}
