//
//  Distance.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

/// Get the distance between two points
final class DistanceProblem {
    let input: Input

    init(input: Input) {
        self.input = input
    }
}

extension DistanceProblem: LLMParsable {
    static let prompt = """
The problem below deals with finding the distance between two points. Please tell me which two points should be used as input, and format it as follows:
p1 = (x1, y1)
p2 = (x2, y2)
"""

    public static func from(llmOutput: String) -> Self {
        fatalError("todo")
    }
}

extension DistanceProblem: Problem {
    public func solve() throws(ProblemError) -> Output {
        let p1 = input.get("p1")?.value as? Point
        let p2 = input.get("p2")?.value as? Point
        guard let p1, let p2 else {
            throw .invalidInput
        }

        let formula = DistanceFormula(input: (p1, p2))
        guard let answer = formula.evaluate() else {
            throw .invalidInput
        }

        return Output(
            steps: [
                Step.applyFormula(formula)
            ],
            answer: OutputValue.value(answer)
        )
    }
}
