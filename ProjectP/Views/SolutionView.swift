//
//  SolutionView.swift
//  ProjectP
//
//  Created by Caelan on 11/15/24.
//

import SwiftUI
import ProjectPLogic
import LaTeXSwiftUI

public struct SolutionView: View {
    let problem: ProblemInput
    let solution: Solution

    @State var showingText: Bool = false

    @Environment(\.dismiss) var dismiss

    public var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("Problem")
                        .font(.headline)
                        .padding(.bottom, 0.01)
                    switch problem {
                        case .text(let string):
                            Text(string)
                        case .image(let image, let text):
                            Button {
                                showingText.toggle()
                            } label: {
                                if showingText {
                                    Text(text)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                } else {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .tint(.primary)
                    }

                    Text("Answer")
                        .font(.headline)
                        .padding(.top)
                        .padding(.bottom, 0.01)
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
