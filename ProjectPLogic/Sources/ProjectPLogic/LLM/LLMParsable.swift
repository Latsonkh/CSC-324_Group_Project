//
//  LLMParsable.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

/// An object that's parsable from an LLM output string
public protocol LLMParsable {
    static func from(llmOutput: String) -> Self
}
