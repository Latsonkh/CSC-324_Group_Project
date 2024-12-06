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
        guard numbers.count >= 5 else { return nil }

        let (vX, vY, aX, aY, t) = (numbers[0], numbers[1], numbers[2], numbers[3], numbers[4])

        guard
            let v = Vector(x: Value(value: vX, unit: .distance(.meter(.base))), y: Value(value: vY, unit: .distance(.meter(.base)))),
            let a = Vector(x: Value(value: aX, unit: .distance(.meter(.base))), y: Value(value: aY, unit: .distance(.meter(.base))))
        else {
            return nil
        }

        let input = Input(
            variables: [
                Variable(name: "v", value: .vector(v)),
                Variable(name: "a", value: .vector(a)),
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
        guard let deltaX = formula.evaluate() else {
            throw .invalidInput
        }

        let distanceFormula = DistanceFormula(input: .init(
            p1: .init(x: .init(value: 0, unit: .distance(.meter(.base))), y: .init(value: 0, unit: .distance(.meter(.base))))!,
            p2: deltaX
        ))
        guard let finalAnswer = distanceFormula.evaluate() else {
            throw .invalidInput
        }

        return Output(
            steps: [
                .applyFormula(.dGivenVAT(formula)),
                .applyFormula(.distance(distanceFormula))
            ],
            answer: .value(finalAnswer)
        )
    }
}
