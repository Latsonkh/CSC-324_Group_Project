//
// PosGivenVTFormula.swift
// ProjectPLogic
//
// Created by Henry on 11/22/24
//

struct PosGivenVTFormula: Formula {

    typealias Input = (Vector, Vector, Value)
    typealias Output = Vector

    let input: Input

    func evaluate() -> Output? {
        let pos = input.0
        let vel = input.1
        let time = input.2

        guard let inner = vel.mult(val: time) else {
            return nil 
        }

        return pos.add(vec: inner)
    }

    func toString() -> String {
        "x_f = x_i + v * t"
    }
}

extension PosGivenVTFormula: CustomStringConvertible {
        var description: String {
            "x_f = x_i + v * t"
        }
}