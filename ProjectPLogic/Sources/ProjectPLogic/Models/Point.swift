//
//  Point.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

import Foundation

public struct Point: Value {
    let x: Double
    let y: Double
}

extension Point: CustomStringConvertible {
    public var description: String {
        "(\(x), \(y))"
    }
}

extension Point {
    func distance(to other: Point) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        return sqrt(dx * dx + dy * dy)
    }
}
