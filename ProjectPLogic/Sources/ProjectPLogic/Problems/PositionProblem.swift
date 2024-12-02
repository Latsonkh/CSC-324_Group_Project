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
    The problem below deals with finding a final displacement vector
    by adding multiple vectors. Identify these vectors and encode them
    as follows:
    
    vOne = (x1, y1)
    vTwo = (x2, y2)
    ...
    vN = (xN, yN)
    
    Do not solve the problem. Do not explain the problem. 
    """
    
    public static func from(llmOutput: String) -> PositionProblem? {
        let numbers = MathParser.getNumbers(from: llmOutput)
        
        let v = { value in
            Value(value: value, unit: .distance(.meter(.kilo)))
        }
        
        var vectors: [Vector] = []
        for idx in stride(from: 0, to: numbers.count, by: 2) {
            let x = numbers[idx]
            let y = numbers[idx + 1]
            
            vectors.append(Vector(x: v(x), y: v(y))!)
        }
        
        let input = Input(variables: vectors.enumerated().map { idx, vector in
            Variable(name: "v\(idx)", value: vector)
        })
        
        return PositionProblem(input: input)
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
