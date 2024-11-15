//
//  Input.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/13/24.
//

public struct Input {
    public let variables: [Variable]
}

public struct Variable {
    public let name: String
    public let value: Any
}

extension Input {
    public func get(_ name: String) -> Variable? {
        variables.first(where: { $0.name == name })
    }
}
