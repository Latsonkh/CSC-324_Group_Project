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

    public static func from(llmOutput: String) -> DistanceProblem? {
        let numbers = getNumbers(from: llmOutput)
        guard numbers.count >= 4 else { return nil }

        let (p1_x, p1_y, p2_x, p2_y) = (numbers[0], numbers[1], numbers[2], numbers[3])
        // todo: parse units
        let v = { value in
            Value(value: value, unit: .distance(.meter(.kilo)))
        }
        guard
            let p1 = Point(x: v(p1_x), y: v(p1_y)),
            let p2 = Point(x: v(p2_x), y: v(p2_y))
        else {
            return nil
        }

        let input = Input(
            variables: [
                Variable(name: "p_1", value: .point(p1)),
                Variable(name: "p_2", value: .point(p2))
            ]
        )

        return DistanceProblem(input: input)
    }

    private static func getNumbers(from string: String) -> [Double] {
        let components = string
            .replacingOccurrences(of: ",", with: " ")
            .replacingOccurrences(of: "(", with: " ")
            .replacingOccurrences(of: ")", with: " ")
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }

        var numbers: [Double] = []

        for component in components {
            // try to convert each component to a Double
            if let number = Double(component.trimmingCharacters(in: .whitespaces)) {
                numbers.append(number)
            } else {
                // try to handle stuff like "1+2" or "1-2"
                let chars = Array(component)
                var currentNumber = ""
                var allNumbers: [Double] = []

                for (index, char) in chars.enumerated() {
                    if char.isNumber || char == "." || (char == "-" && index == 0) {
                        currentNumber.append(char)
                    } else if char == "+" || char == "-" {
                        if let num = Double(currentNumber) {
                            allNumbers.append(num)
                        }
                        currentNumber = String(char)
                    }
                }

                if !currentNumber.isEmpty, let lastNum = Double(currentNumber) {
                    allNumbers.append(lastNum)
                }

                if allNumbers.count == 2 {
                    let result = (chars.contains("+")) ?
                        allNumbers[0] + allNumbers[1] :
                        allNumbers[0] - allNumbers[1]
                    numbers.append(result)
                }
            }
        }

        return numbers
    }
}

extension DistanceProblem: Problem {
    public func solve() throws(ProblemError) -> Output {
        guard
            case let .point(p1) = input.get("p_1")?.value,
            case let .point(p2) = input.get("p_2")?.value
        else {
            throw .invalidInput
        }

        let formula = DistanceFormula(input: PointPair(p1: p1, p2: p2))
        guard let answer = formula.evaluate() else {
            throw .invalidInput
        }

        return Output(
            steps: [
                Step.applyFormula(.distance(formula))
            ],
            answer: OutputValue.value(answer)
        )
    }
}
