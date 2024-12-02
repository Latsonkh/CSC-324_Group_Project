//
//  Distance.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/13/24.
//

public struct PointPair: Sendable, Codable {
    let p1: Point
    let p2: Point
}

public struct DistanceFormula: Formula {
    public typealias Input = PointPair
    public typealias Output = Value

    public let input: Input

    public func evaluate() -> Output? {
        input.p1.distance(to: input.p2)
    }
}

extension DistanceFormula: CustomStringConvertible {
    public var description: String {
        "d=\\sqrt{(x_1 - x_2)^2 + (y_1 - y_2)^2}"
//        "d=\\sqrt{(\(input.0.x.value - input.1.x.value))^2 + (\(input.0.y.value - input.1.y.value))^2}"
    }
}
