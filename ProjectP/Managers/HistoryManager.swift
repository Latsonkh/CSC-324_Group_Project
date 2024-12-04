//
//  HistoryManager.swift
//  ProjectP
//
//  Created by Caelan on 12/2/24.
//

import Foundation

class HistoryManager {
    static let key = "history"

    static func get() -> [SolutionData] {
        guard let historyData = UserDefaults.standard.data(forKey: key) else {
            return []
        }

        guard let solutions = try? JSONDecoder().decode([SolutionData].self, from: historyData) else {
            save(solutions: [])
            return []
        }

        return solutions
    }

    static func save(solutions: [SolutionData]) {
        UserDefaults.standard.set(try? JSONEncoder().encode(solutions), forKey: key)
    }

    static func add(solution: SolutionData) {
        var history = get()
        history.append(solution)
        save(solutions: history)
    }

    static func delete(solution: SolutionData) {
        var history = get()
        history.removeAll { $0.id == solution.id }
        save(solutions: history)
    }
}
