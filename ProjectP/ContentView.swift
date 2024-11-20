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

    var body: some View {
        Group {
            if loading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
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

                Button("Scan Problem") {
                    showingDocumentScanner = true
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
        .sheet(isPresented: $showingDocumentScanner) {
            DocumentScannerView { scannedImage in
                if let image = scannedImage {
                    self.scannedImage = image
                    self.problem = .image(image)
                    self.loading = true

                    Task {
                        do {
                            let exampleSolution = try await exampleDistanceProblem()
                            self.solution = exampleSolution
                            self.showingSolution = true
                            self.loading = false
                        } catch {
                            print("Error fetching solution:", error)
                            self.loading = false
                        }
                    }
                }
                self.showingDocumentScanner = false
            }
        }
    }
}

struct DocumentScannerView: UIViewControllerRepresentable {
    var completion: (UIImage?) -> Void

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }

    class Coordinator: NSObject, @preconcurrency VNDocumentCameraViewControllerDelegate {
        var completion: (UIImage?) -> Void

        init(completion: @escaping (UIImage?) -> Void) {
            self.completion = completion
        }

        @MainActor func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
            completion(nil)
        }

        @MainActor func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document scanning failed with error:", error.localizedDescription)
            controller.dismiss(animated: true)
            completion(nil)
        }

        @MainActor func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true)

            guard scan.pageCount > 0 else {
                completion(nil)
                return
            }

            let scannedImage = scan.imageOfPage(at: 0)
            completion(scannedImage)
        }
    }
}
