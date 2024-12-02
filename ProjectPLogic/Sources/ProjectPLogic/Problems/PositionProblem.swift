//
// PositionProblem.swift
// ProjectPLogic
//
// Created by Henry on 11/20/24
//

final class PositionProblem {
    let input: Input

    init(input: Input) {
        self.input = input
    }
}

extension PositionProblem: LLMParsable {
    // TODO: write prompt
    static let prompt = "this prompt is not yet written"

    public static func from(llmOutput: String) -> Self? {
        fatalError("todo")
    }
}

extension PositionProblem: Problem {
    public func solve() throws(ProblemError) -> Output {
        let vectors: [Vector] = input.variables.compactMap {
            if case .vector(let value) = $0.value {
                value
            } else {
                nil
            }
        }

        let formula = AddVectorsFormula(input: vectors)
        guard let answer = formula.evaluate() else {
            throw .invalidInput
        }

        return Output(
            steps: [
                Step.applyFormula(.addVectors(formula))
            ],
            answer: OutputValue.vector(answer)
        )
    }
}
