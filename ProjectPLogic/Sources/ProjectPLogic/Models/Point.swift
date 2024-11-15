//
//  Point.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

import Foundation

/// A tuple with x and y values, representing a 2d point.
struct Point {
    let x: Value
    let y: Value

    // failable initializer that requires x and y values have distance units
    init?(x: Value, y: Value) {
        guard case .distance(_) = x.unit, case .distance(_) = y.unit else {
            return nil
        }
        self.x = x
        self.y = y
    }
}

extension Point: CustomStringConvertible {
    var description: String {
        "(\(x), \(y))"
    }
}

extension Point {
    /// Gets the distance to the given point.
    ///
    /// Returns nil if value conversion fails.
    func distance(to other: Point) -> Value? {
        let targetUnit = x.unit
        guard
            let otherX = other.x.converted(to: targetUnit),
            let y = y.converted(to: targetUnit),
            let otherY = other.y.converted(to: targetUnit)
        else {
            return nil
        }

        let dx = x.value - otherX.value
        let dy = y.value - otherY.value

        return Value(value: sqrt(dx * dx + dy * dy), unit: targetUnit)
    }
}
