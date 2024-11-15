//
//  StepView.swift
//  ProjectP
//
//  Created by Caelan on 11/15/24.
//

import SwiftUI
import ProjectPLogic

public struct StepView: View {
    let number: Int
    let step: Step

    public var body: some View {
        CardView(title: "Step \(number)", content: step.toString())
    }
}

public struct CardView: View {
    let title: String
    let content: String

    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(.secondary)
            Text(content)
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
