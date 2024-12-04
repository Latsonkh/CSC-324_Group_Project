//
//  AddVectorsFormula.swift
//  ProjectPLogic
//
//  Created by Henry on 11/18/24
//

public struct AddVectorsFormula: Formula {
    public typealias Input = [Vector]
    public typealias Output = Point

    public let input: Input

    public func evaluate() -> Output? {
        // Sum the x and y components of vectors in the array
        var totalX = 0.0
        var totalY = 0.0

        for v in input {
            totalX += v.x.value
            totalY += v.y.value
        }

        // return a vector that is a sum of all input vectors
        return Vector(
            x: Value(value: totalX, unit: .distance(.meter(.kilo))),
            y: Value(value: totalY, unit: .distance(.meter(.kilo)))
        )
    }

    public var description: String {
        "v_1 + v_2 + v_3 ..."
    }
}
