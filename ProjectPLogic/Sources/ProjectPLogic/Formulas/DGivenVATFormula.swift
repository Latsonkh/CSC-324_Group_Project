//
//  DGivenVATFormula.swift
//  ProjectPLogic
//
//  Created by Henry on 12/5/24.
//

// needs to be a struct so that it is codable
public struct DGivenVATFormulaInput: Sendable, Codable {
    let initVel: Vector
    let acc: Vector
    let time: Value
}

public struct DGivenVATFormula: Formula {
    public typealias Input = DGivenVATFormulaInput
    public typealias Output = Vector

    public let input: Input

    public func evaluate() -> Output? {
        let initVel = input.initVel
        let acc = input.acc
        let time = input.time.value
        return Vector(
            x: Value(value: eval1D(initVel: initVel.x.value, acc: acc.x.value, time: time), unit: .distance(.meter(.base))),
            y: Value(value: eval1D(initVel: initVel.y.value, acc: acc.y.value, time: time), unit: .distance(.meter(.base)))
        )
    }

    // computes the equation for a single dimension
    private func eval1D(initVel: Double, acc: Double, time: Double) -> Double {
        return (initVel * time) + (0.5 * acc * (time*time))
    }
}
extension DGivenVATFormula: CustomStringConvertible {
    public var description: String {
        "\\Delta x = v_0 * t + \\frac{1}{2} a * t^2"
    }
}
