//
//  Value.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

/// A numeric value with an associated unit
public struct Value: Sendable {
    let value: Double
    let unit: Unit
}

extension Value {
    /// Converts a given value to a value with a different unit.
    ///
    /// Returns nil when the conversion fails.
    public func converted(to unit: Unit) -> Value? {
        if self.unit == unit {
            return self
        }

        switch (self.unit, unit) {
            case let (.distance(x), .distance(y)):
                let factor = x.conversionFactor(to: y)
                return .init(value: value * factor, unit: unit)
            default:
                return nil
        }

    }
}

extension Value: CustomStringConvertible {
    public var description: String {
        "\(value) \(unit.suffix)"
    }
}
