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
    static let prompt = """
    The problem below deals with adding different vectors. 
    Identify all the vectors problem, and encode them as follows:
    pA = (x1, y1)
    pB = (x2, y2)
    ...

    Do not solve the problem. Do not explain the problem. 
    """

    public static func from(llmOutput: String) -> Self? {
        let numbers = StringParser.getNumbers(from: llmOutput)
        if numbers.count % 2 != 0 {
            // must have an even amount
            return nil
        }

        let vectors: [Vector] = stride(from: 0, to: numbers.count, by: 2).compactMap {
            Vector(
                x: .init(value: numbers[$0], unit: .distance(.meter(.kilo))),
                y: .init(value: numbers[$0 + 1], unit: .distance(.meter(.kilo)))
            )
        }

        return Self(input: .init(variables: vectors.enumerated().map {
            Variable(name: "v_\($0.offset + 1)", value: .vector($0.element))
        }))
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
