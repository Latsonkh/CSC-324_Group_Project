//
//  Unit.swift
//  ProjectPLogic
//
//  Created by Caelan on 11/11/24.
//

public enum Unit: Equatable {
    case none // temporary
    case distance(DistanceUnit)
}

extension Unit {
    var suffix: String {
        switch self {
            case .none: ""
            case .distance(let unit): unit.suffix
        }
    }
}

public enum MetricUnit: Equatable {
    case milli
    case centi
    case deci
    case base
    case kilo
}

extension MetricUnit {
    var baseFactor: Double {
        switch self {
            case .milli: 0.001
            case .centi: 0.01
            case .deci:  0.1
            case .base:  1.0
            case .kilo:  1000.0
        }
    }
}

// MARK: - Distance

public enum DistanceUnit: Equatable {
    case meter(MetricUnit)
    case customary(CustomaryDistanceUnit)
}

public enum CustomaryDistanceUnit: Equatable {
    case inch
    case foot
    case yard
    case mile
}

extension CustomaryDistanceUnit {
    var meterFactor: Double {
        switch self {
            case .inch: 0.0254
            case .foot: 0.3048
            case .yard: 0.9144
            case .mile: 1609.344
        }
    }
}

extension DistanceUnit {
    var suffix: String {
        switch self {
            case .meter(let metricUnit):
                switch metricUnit {
                    case .milli: "mm"
                    case .centi: "cm"
                    case .deci:  "dm"
                    case .base:  "m"
                    case .kilo:  "km"
                }
            case .customary(let customaryDistanceUnit):
                switch customaryDistanceUnit {
                    case .inch: "in"
                    case .foot: "ft"
                    case .yard: "yd"
                    case .mile: "mi"
                }
        }
    }

    private var meterFactor: Double {
        switch self {
            case .meter(let unit):
                unit.baseFactor
            case .customary(let unit):
                unit.meterFactor
        }
    }

    func conversionFactor(to destination: DistanceUnit) -> Double {
        let sourceInMeters = self.meterFactor
        switch destination {
            case .meter(let destinationUnit):
                return sourceInMeters / destinationUnit.baseFactor
            case .customary(let destinationUnit):
                return sourceInMeters / destinationUnit.meterFactor
        }
    }
}
