//
//  ContentView.swift
//  ProjectP
//
//  Created by Caelan on 11/4/24.
//

import SwiftUI
import VisionKit
import ProjectPLogic

enum ProblemInput: Identifiable {
    var id: Int {
        switch self {
            case .text(let string):
                string.hashValue
            case .image(let image):
                image.hashValue
        }
    }

    case text(String)
    case image(UIImage)
}

extension ProblemInput: Codable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let data = try? container.decode(Data.self), let image = UIImage(data: data) {
            self = .image(image)
        } else if let string = try? container.decode(String.self) {
            self = .text(string)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected String or UIImage")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .text(let string):
                try container.encode(string)
            case .image(let image):
                try container.encode(image.pngData())
        }
    }
}

struct SolutionData: Identifiable, Codable {
    var id: Int {
        problem.id
    }

    let problem: ProblemInput
    let solution: Solution
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme

    @State private var solutionData: SolutionData?

    @State private var loading = false

    @State private var showingDocumentScanner = false
    @State private var scannedImage: UIImage?

    @State private var error: Error?
    @State private var showingErrorAlert = false

    @State private var searchText: String = ""

    @State private var history: [SolutionData]?

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()

                VStack {
                    ZStack {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                if let history {
                                    ForEach(history.reversed()) { item in
                                        historyButton(for: item)
                                    }
                                } else {
                                    ProgressView().progressViewStyle(.circular)
                                }
                            }
                            .padding(.bottom, 50)
                        }
                        .mask(LinearGradient(
                            gradient: Gradient(colors: [.black, .black, .black, .clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    }

                    Button {
                        showingDocumentScanner = true
                    } label: {
                        Label("Scan Problem", systemImage: "text.viewfinder")
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 24)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.tint)
                            .shadow(color: .black.opacity(colorScheme == .dark ? 0.1 : 0.05), radius: 6, y: 6)
                    )
                    .padding(.bottom)
                }

            }
            .navigationTitle("Physics Helper")
            .searchable(text: $searchText)
        }
        .fullScreenCover(item: $solutionData) { data in
            SolutionView(problem: data.problem, solution: data.solution)
        }
        .fullScreenCover(isPresented: $showingDocumentScanner) {
            CameraView { image in
                self.scannedImage = image
                self.loading = true
                Task {
                    do {
                        let problem = try await ImageManager.extractText(from: image)
                        print("got problem:", problem)
                        let solution = try await solve(problem: problem)
                        let solutionData = SolutionData(problem: .image(image), solution: solution)
                        self.solutionData = solutionData
                        HistoryManager.add(solution: solutionData)
                        history?.append(solutionData)
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
        .onAppear {
            if history == nil {
                Task.detached {
                    let history = HistoryManager.get()
                    await MainActor.run {
                        self.history = history
                    }
                }
            }
        }
    }

    @ViewBuilder
    func historyButton(for data: SolutionData) -> some View {
        let button = Button {
            self.loading = true
            self.solutionData = data
        } label: {
            switch data.problem {
                case .text(let text):
                    Text(text)
                case .image(let image):
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
            }
        }
        .contextMenu {
            Button(role: .destructive) {
                HistoryManager.delete(solution: data)
                history?.removeAll { $0.id == data.id }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }

        if case .text = data.problem {
            button.buttonStyle(HistoryButtonStyle())
        } else {
            button.buttonStyle(HistoryImageButtonStyle())
        }
    }
}
