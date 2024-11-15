//
//  Distance.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/13/24.
//

struct DistanceFormula: Formula {
    typealias Input = (Point, Point)
    typealias Output = Value

    let input: Input

    func evaluate() -> Output? {
        input.0.distance(to: input.1)
    }

    func toString() -> String {
        "sqrt((x1 - x2)^2 + (y1 - y2)^2)"
    }
}
