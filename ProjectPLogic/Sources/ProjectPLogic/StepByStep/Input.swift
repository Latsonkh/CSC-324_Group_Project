//
//  Input.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/13/24.
//

public struct Input: Sendable {
    public let variables: [Variable]
}

public struct Variable: Sendable {
    public let name: String
    public let value: any Sendable
}

extension Input {
    public func get(_ name: String) -> Variable? {
        variables.first(where: { $0.name == name })
    }
}
