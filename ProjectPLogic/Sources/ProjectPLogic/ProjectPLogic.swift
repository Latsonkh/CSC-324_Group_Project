// The Swift Programming Language
// https://docs.swift.org/swift-book

public func exampleDistanceProblem() async throws -> Solution {
//    let problem = """
//A person walks in the following pattern: 3.1 km north, then 2.4 km west, and finally 5.2km south. How far could a bird fly in a straight line from the same starting point to the same final point?
//"""
//
//    let llmClassification = await LLMHandler.shared.classify(problem: problem)
//     ...

    let input = Input(variables: [
        Variable(
            name: "p1",
            value: Point(
                x: Value(value: 0, unit: .distance(.meter(.kilo))),
                y: Value(value: 0, unit: .distance(.meter(.kilo)))
            )!
        ),
        Variable(
            name: "p2",
            value: Point(
                x: Value(value: -2.4, unit: .distance(.meter(.kilo))),
                y: Value(value: 3.1 - 5.2, unit: .distance(.meter(.kilo)))
            )!
        )
    ])

    let problemOutput = try DistanceProblem(input: input).solve()

    return Solution(
        classification: .twoPointsDistance,
        input: input,
        output: problemOutput
    )
}
