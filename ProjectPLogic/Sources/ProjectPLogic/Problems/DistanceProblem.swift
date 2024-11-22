//
//  Distance.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

import Foundation

/// Get the distance between two points
final class DistanceProblem {
    let input: Input

    init(input: Input) {
        self.input = input
    }
}

extension DistanceProblem: LLMParsable {
    static let prompt = """
    The problem below deals with finding the distance between two points. 
    Identify the two points in the problem, and encode them as follows:
    pA = (x1, y1)
    pB = (x2, y2)
    
    Do not solve the problem. Do not explain the problem. 
    """

    public static func from(llmOutput: String) -> DistanceProblem {
        let numberPattern = #"[-]?\d+(\.\d+)?(?:\s*[-+]\s*\d+(\.\d+)?)?"#
        
        let regex = try! NSRegularExpression(pattern: numberPattern)
        let matches = regex.matches(in: llmOutput, range: NSRange(llmOutput.startIndex..., in: llmOutput))

        var numbers = [Double]()
        for match in matches {
            let matchRange = Range(match.range, in: llmOutput)!
            let expression = String(llmOutput[matchRange])
            
            let expr = NSExpression(format: expression)
            if let value = expr.expressionValue(with: nil, context: nil) as? Double {
                numbers.append(value)
            }
        }

        let (p1_x, p1_y, p2_x, p2_y) = (numbers[0], numbers[1], numbers[2], numbers[3])
        // todo: parse units
        let v = { value in
            Value(value: value, unit: .distance(.meter(.kilo)))
        }
        guard
            let p1 = Point(x: v(p1_x), y: v(p1_y)),
            let p2 = Point(x: v(p2_x), y: v(p2_y))
        else {
            fatalError("invalid output")
        }
        let input = Input(
            variables: [
                Variable(name: "p_1", value: p1),
                Variable(name: "p_2", value: p2)
            ]
        )

        return DistanceProblem(input: input)
    }
}

extension DistanceProblem: Problem {
    public func solve() throws(ProblemError) -> Output {
        let p1 = input.get("p_1")?.value as? Point
        let p2 = input.get("p_2")?.value as? Point
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
