import SwiftUI
import VisionKit
import ProjectPLogic

enum ProblemInput {
    case text(String)
    case image(UIImage)
}

struct Solution {
    let result: String
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
                            let exampleSolution = try await fetchExampleSolution()
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

struct SolutionView: View {
    let problem: ProblemInput
    let solution: Solution

    var body: some View {
        VStack {
            Text("Solution")
                .font(.title)
                .padding()

            switch problem {
            case .text(let text):
                Text("Problem: \(text)")
            case .image(_):
                Text("Problem: Scanned Image")
            }

            Text("Solution: \(solution.result)")
                .padding()

            Button("Close") {
                // Handle closing
            }
        }
        .padding()
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

func fetchExampleSolution() async throws -> Solution {
    return Solution(result: "Example solution result.")
}
