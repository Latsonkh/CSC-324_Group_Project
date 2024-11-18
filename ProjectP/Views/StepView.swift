//
//  StepView.swift
//  ProjectP
//
//  Created by Caelan on 11/15/24.
//

import SwiftUI
import ProjectPLogic
import LaTeXSwiftUI

public struct StepView: View {
    let number: Int
    let step: Step

    public var body: some View {
        CardView(title: "Step \(number)", content: step.toString())
    }
}

public struct CardView<Content: View>: View {
    let title: String
    let content: () -> Content

    init(title: String, content: String) where Content == LaTeX {
        self.title = title
        self.content = {
            LaTeX(content)
        }
    }

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(.secondary)
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(UIColor.quaternarySystemFill), lineWidth: 1)
        )
    }
}
