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

}

extension DistanceFormula: CustomStringConvertible {
    var description: String {
        "d=\\sqrt{(x_1 - x_2)^2 + (y_1 - y_2)^2}"
//        "d=\\sqrt{(\(input.0.x.value - input.1.x.value))^2 + (\(input.0.y.value - input.1.y.value))^2}"
    }
}
