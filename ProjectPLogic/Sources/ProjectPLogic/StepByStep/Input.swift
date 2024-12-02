//
//  Input.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/13/24.
//

public struct Input: Sendable, Codable {
    public let variables: [Variable]
}

public enum VariableValue: Sendable, Codable {
    case double(Double)
    case string(String)
    case int(Int)
    case point(Point)
    case vector(Vector)
}

extension VariableValue: CustomStringConvertible {
    public var description: String {
        switch self {
            case .double(let value): value.description
            case .string(let value): value.description
            case .int(let value): value.description
            case .point(let value): value.description
            case .vector(let value): value.description
        }
    }
}

public struct Variable: Sendable, Codable {
    public let name: String
    public let value: VariableValue
}

extension Input {
    public func get(_ name: String) -> Variable? {
        variables.first(where: { $0.name == name })
    }
}
