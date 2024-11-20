//
//  Solution.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/13/24.
//

public struct Solution: Sendable {
    public let classification: Classification
    let input: Input
    let output: Output

    public let steps: [Step]
    public var answer: OutputValue {
        output.answer
    }

    init(classification: Classification, input: Input, output: Output) {
        self.classification = classification
        self.input = input
        self.output = output

        self.steps = [
            .classify(classification),
            .setupInput(input)
        ] + output.steps
    }
}
