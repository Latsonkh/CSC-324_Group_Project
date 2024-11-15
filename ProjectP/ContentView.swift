//
//  ContentView.swift
//  ProjectP
//
//  Created by Caelan on 11/4/24.
//

import SwiftUI
import ProjectPLogic

enum ProblemInput {
    case text(String)
    // todo: images
}

struct ContentView: View {
    @State private var loading = false
    @State private var showingSolution = false
    @State private var problem: ProblemInput?
    @State private var solution: Solution?

    var body: some View {
        Group {
            if loading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Button("Try Example Problem") {
                    self.loading = true
                    Task {
                        do {
                            let exampleSolution = try await exampleDistanceProblem()
                            // swiftlint:disable line_length
                            self.problem = ProblemInput.text("""
    A person walks in the following pattern: 3.1 km north, then 2.4 km west, and finally 5.2km south. How far could a bird fly in a straight line from the same starting point to the same final point?
    """)
                            // swiftlint:enable line_length
                            self.solution = exampleSolution
                            self.showingSolution = true
                            self.loading = false
                        } catch {
                            print("error:", error)
                            self.loading = false
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showingSolution) {
            if let problem, let solution {
                SolutionView(
                    problem: problem,
                    solution: solution
                )
            } else {
                Text("Error")
            }
        }
    }
}

#Preview {
    ContentView()
}
