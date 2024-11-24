//
//  ContentView.swift
//  ProjectP
//
//  Created by Caelan on 11/4/24.
//

import SwiftUI
import VisionKit
import ProjectPLogic

enum ProblemInput {
    case text(String)
    case image(UIImage)
}

struct ContentView: View {
    @State private var loading = false
    @State private var showingSolution = false
    @State private var problem: ProblemInput?
    @State private var solution: Solution?

    @State private var showingDocumentScanner = false
    @State private var scannedImage: UIImage?

    @State private var error: Error?
    @State private var showingErrorAlert = false

    var body: some View {
        Group {
            if loading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                VStack(spacing: 12) {
                    Button("Scan Problem") {
                        showingDocumentScanner = true
                    }

                    Button("Try Example Problem") {
                        self.loading = true
                        Task {
                            let exampleSolution = try await exampleDistanceProblem()
                            // swiftlint:disable line_length
                            self.problem = ProblemInput.text("""
A person walks in the following pattern: 3.1 km north, then 2.4 km west, and finally 5.2km south. How far could a bird fly in a straight line from the same starting point to the same final point?
""")
                            // swiftlint:enable line_length
                            self.solution = exampleSolution
                            self.showingSolution = true
                            self.loading = false
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showingSolution) {
            if let problem, let solution {
                SolutionView(problem: problem, solution: solution)
            } else {
                Text("Error")
            }
        }
        .fullScreenCover(isPresented: $showingDocumentScanner) {
            CameraView { image in
                self.scannedImage = image
                self.problem = .image(image)
                self.loading = true

                Task {
                    do {
                        let problem = try await ImageManager.extractText(from: image)
                        print("got problem:", problem)
                        let exampleSolution = try await solve(problem: problem)
                        self.solution = exampleSolution
                        self.showingSolution = true
                        self.loading = false
                    } catch {
                        print("error:", error, error.localizedDescription)
                        self.error = error
                        self.showingErrorAlert = true
                        self.loading = false
                    }
                }
                self.showingDocumentScanner = false
            }
            .ignoresSafeArea()
        }
        .alert("Error", isPresented: $showingErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(error?.localizedDescription ?? "Error encountered while fetching solution.")
        }
    }
}
