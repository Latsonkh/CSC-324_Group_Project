// The Swift Programming Language
// https://docs.swift.org/swift-book


public func exampleDistanceProblem() async throws -> Solution {
//    let problem = """
//A person walks in the following pattern: 3.1 km north, then 2.4 km west, and finally 5.2km south. How far could a bird fly in a straight line from the same starting point to the same final point?
//"""
//
//    let llmClassification = await LLMHandler.shared.classify(problem: problem)
//     ...

    let points = (Point(x: 0, y: 0), Point(x: -2.4, y: 3.1 - 5.2))

    let input = Input(variables: [Variable(name: "p1", value: points.0), Variable(name: "p2", value: points.1)])

    let problemOutput = try DistanceProblem(input: input).solve()

    return Solution(
        classification: .twoPointsDistance,
        input: input,
        output: problemOutput
    )
}
