//
// AddVectorsFormula.swift
// ProjectPLogic
//
// Created by Henry on 11/18/24
//

struct AddVectorsFormula: Formula {
    typealias Input = [Vector]
    typealias Output = Point

    let input: Input

    func evaluate() -> Output? {

        // Sum the x and y components of vectors in the array
        var totalx:Double = 0;
        var totaly:Double = 0;

        for v in input {
            totalx += v.x.value
            totaly += v.y.value
        }

        // return a vector that is a sum of all input vectors
        return Vector.init(x: Value.init(value: totalx, unit: Unit.none), y: Value.init(value: totaly, unit: Unit.none))
    }

    func toString() -> String {
        "v1 + v2 + v3 ..."
    }
}