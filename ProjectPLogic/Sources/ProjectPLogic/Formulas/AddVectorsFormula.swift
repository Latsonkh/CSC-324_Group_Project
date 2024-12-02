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
        var totalx: Double = 0
        var totaly: Double = 0

        for v in input {
            totalx += v.x.value
            totaly += v.y.value
        }

        // return a vector that is a sum of all input vectors
        return Vector.init(x: Value(value: totalx, unit: Unit.none), y: Value(value: totaly, unit: Unit.none))
    }

    public var description: String {
        "v_1 + v_2 + v_3 ..."
    }
}
