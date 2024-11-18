//
//  SolutionView.swift
//  ProjectP
//
//  Created by Caelan on 11/15/24.
//

import SwiftUI
import ProjectPLogic
import LaTeXSwiftUI

// UIKit close button for SwiftUI
private struct CloseButton: UIViewRepresentable {
    private let action: () -> Void

    init(action: @escaping () -> Void) { self.action = action }

    func makeUIView(context: Context) -> UIButton {
        UIButton(type: .close, primaryAction: UIAction { _ in action() })
    }

    func updateUIView(_ uiView: UIButton, context: Context) {}
}

public struct SolutionView: View {
    let problem: ProblemInput
    let solution: Solution

    @Environment(\.dismiss) var dismiss

    public var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("Problem")
                        .font(.headline)
                    switch problem {
                        case .text(let string):
                            Text(string)
                    }

                    Text("Answer")
                        .font(.headline)
                        .padding(.top)
                    LaTeX("$\(solution.answer.description)$")
                }
                .padding()
                .padding(.top, 0)
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    Text("Steps")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)

                VStack(spacing: 16) {
                    ForEach(Array(solution.steps.enumerated()), id: \.offset) { idx, step in
                        if case let .classify(classification) = step {
                            CardView(title: "Step \(idx + 1)") {
                                Text("Identify problem type:")
                                Button {
                                    print("todo")
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(classification.description)
                                        Image(systemName: "info.circle.fill")
                                    }
                                }
                            }
                        } else {
                            StepView(number: idx + 1, step: step)
                        }
                    }
                    CardView(title: "Answer", content: "$\(solution.answer.description)$")
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CloseButton {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {

                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
