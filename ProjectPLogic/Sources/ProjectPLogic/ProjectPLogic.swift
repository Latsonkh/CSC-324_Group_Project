// The Swift Programming Language
// https://docs.swift.org/swift-book

public func exampleDistanceProblem() async throws -> Solution {
    let problem = """
    A person walks in the following pattern: 3.1 km north, then 2.4 km west, and finally 5.2km south. How far could a bird fly in a straight line from the same starting point to the same final point?
    """
    
    let solution = try! await LLMHandler.shared.solve(problem: problem)
    
    guard let solution else {
        fatalError("Could not solve the problem.")
    }
    
    return solution
}
