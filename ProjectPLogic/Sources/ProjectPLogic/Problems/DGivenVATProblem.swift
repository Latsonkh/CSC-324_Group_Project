//
//  DGivenVATProblem.swift
//  ProjectPLogic
//
//  Created by Henry on 12/6/24.
//

import Foundation

final class DGivenVATProblem {
    let input: Input

    init(input: Input) {
        self.input = input
    }
}

extension DGivenVATProblem: LLMParsable {
    static let prompt = """
    The problem below deals with finding the distance travelled given a starting velocity vector,
    an acceleration vector, and an amount of time.
    Identify the velocity vector, acceleration vector, and amount of time, and encode them as follows:
    startVel = (vx, vy)
    accel = (ax, ay)
    time = t

    Do not solve the problem. Do not explain the problem. 
    """

    public static func from(llmOutput: String) -> DGivenVATProblem? {
        let numbers = StringParser.getNumbers(from: llmOutput)
        guard numbers.count >= 4 else { return nil }

        let (v_x, v_y, a_x, a_y, t) = (numbers[0], numbers[1], numbers[2], numbers[3], numbers[4])

        guard
            let v = Point(x: Value(value: v_x, unit: .none), y: Value(value: v_y, unit: .none)),
            let a = Vector(x: Value(value: a_x, unit: .none), y: Value(value: a_y, unit: .none))
        else {
            return nil
        }

        let input = Input(
            variables: [
                Variable(name: "v", value: .point(v)),
                Variable(name: "a", value: .point(a)),
                Variable(name: "t", value: .double(t))
            ]
        )

        return DGivenVATProblem(input: input)
    }
}

extension DGivenVATProblem: Problem {
    public func solve() throws(ProblemError) -> Output {
        guard
            case let .vector(v) = input.get("v")?.value,
            case let .vector(a) = input.get("a")?.value,
            case let .double(t) = input.get("t")?.value
        else {
            throw .invalidInput
        }

        let formula = DGivenVATFormula(input: DGivenVATFormulaInput(initVel: v, acc: a, time: Value(value: t, unit: .none)))
        guard let answer = formula.evaluate() else {
            throw .invalidInput
        }

        return Output(
            steps: [
                Step.applyFormula(.dGivenVAT(formula))
            ],
            answer: OutputValue.vector(answer)
        )
    }
}
