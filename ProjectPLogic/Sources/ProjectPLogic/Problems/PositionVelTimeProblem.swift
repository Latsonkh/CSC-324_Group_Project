//
// PositionVelTimeProblem.swift
// ProjectPLogic
//
// Created by Henry on 11/22/24
//

final class PositionVelTimeProblem{
    let input: Input

    init(input: Input) {
        self.input = input
    }
}

extension PositionVelTimeProblem: LLMParsable {
    // TODO: write prompt
    static let prompt = "this prompt is not yet written"

    public static func from(llmOutput: String) -> Self {
        fatalError("todo")
    }
}

extension PositionVelTimeProblem: Problem {
    public func solve() throws(ProblemError) -> Output {
        let x1 = input.get("x1")?.value as? Point
        let v = input.get("v")?.value as? Vector
        let t = input.get("t")?.value as? Value
        guard let x1, let v, let t else {
            throw .invalidInput
        }

        let formula = PosGivenVTFormula(input: (x1, v, t))

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