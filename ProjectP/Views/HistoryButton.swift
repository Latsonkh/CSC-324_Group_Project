//
//  HistoryButton.swift
//  ProjectP
//
//  Created by Caelan on 12/2/24.
//

import SwiftUI

struct HistoryButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: colorScheme == .dark ? .tertiarySystemFill : .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.1 : 0.05), radius: 6, y: 6)
        .scaleEffect(configuration.isPressed ? 0.96 : 1)
        .animation(.linear(duration: 0.1), value: configuration.isPressed)
        .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct HistoryImageButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(uiColor: colorScheme == .dark ? .tertiarySystemFill : .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.1 : 0.05), radius: 6, y: 6)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.linear(duration: 0.1), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}
