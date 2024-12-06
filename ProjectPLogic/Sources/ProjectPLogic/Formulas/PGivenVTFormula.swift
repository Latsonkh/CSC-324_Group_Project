//
//  PGivenVT.swift
//  ProjectPLogic
//
//  Created by Henry on 12/5/24.
//

// needs to be a struct so that it is codable
public struct PGivenVTFormulaInput: Sendable, Codable {
    let initPos: Point
    let vec: Vector
    let time: Value
}

public struct PGivenVTFormula: Formula {
    public typealias Input = PGivenVTFormulaInput
    public typealias Output = Point

    public let input: Input

    public func evaluate() -> Output? {
        let initPos = input.initPos
        let vec = input.vec
        let time = input.time.value
        return Point(
            x: Value(value: initPos.x.value + (vec.x.value * time), unit: Unit.none),
            y: Value(value: initPos.y.value + (vec.y.value * time), unit: Unit.none)
        )
    }
}

extension PGivenVTFormula: CustomStringConvertible {
    public var description: String {
        "p_1 = p_0 + v * t"
    }
}
