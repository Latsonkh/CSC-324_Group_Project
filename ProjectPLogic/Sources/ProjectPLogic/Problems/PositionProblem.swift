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

    public static func from(llmOutput: String) -> Self {
        fatalError("todo")
    }
}

extension PositionProblem: Problem {
    public func solve() throws(ProblemError) -> Output {
        let vectors: [Vector] = input.variables.compactMap {
            $0.value as? Vector
        }

        let formula = AddVectorsFormula(input: vectors)
        guard let answer = formula.evaluate() else {
            throw .invalidInput
        }

        return Output(
            steps: [
                Step.applyFormula(formula)
            ],
            answer: OutputValue.vector(answer)
        )
    }
}
