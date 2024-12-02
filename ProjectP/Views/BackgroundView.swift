//
//  BackgroundView.swift
//  ProjectP
//
//  Created by Caelan on 11/25/24.
//

import SwiftUI

private struct Blob: View {
    let proxy: GeometryProxy
    let color: Color
    let rotation: Double
    let alignment: Alignment

    private let offset = CGSize(
        width: CGFloat.random(in: -150 ..< 150),
        height: CGFloat.random(in: -150 ..< 150)
    )
    private let frameHeightRatio = CGFloat.random(in: 0.7 ..< 1.4)

    var body: some View {
        Circle()
            .fill(color)
            .offset(offset)
            .rotationEffect(.init(degrees: rotation) )
            .frame(height: proxy.size.height / frameHeightRatio)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .opacity(0.8)
    }
}

struct BackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    let blur: CGFloat = 100

    enum Theme {
        static let background = Color(red: 42 / 255, green: 9 / 255, blue: 55 / 255)
        static let topLeading = Color(red: 120 / 255, green: 44 / 255, blue: 209 / 255)
        static let topTrailing = Color(red: 231 / 255, green: 0, blue: 0)
        static let bottomTrailing = Color(red: 176 / 255, green: 27 / 255, blue: 198 / 255)
        static let bottomLeading = Color(red: 0, green: 148 / 255, blue: 254 / 255)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Theme.background

                ZStack {
                    Blob(
                        proxy: proxy,
                        color: Theme.topTrailing,
                        rotation: 240,
                        alignment: .topTrailing
                    )
                    Blob(
                        proxy: proxy,
                        color: Theme.topLeading,
                        rotation: 180,
                        alignment: .topLeading
                    )
                    Blob(
                        proxy: proxy,
                        color: Theme.bottomLeading,
                        rotation: 120,
                        alignment: .bottomLeading
                    )
                    Blob(
                        proxy: proxy,
                        color: Theme.bottomTrailing,
                        rotation: 0,
                        alignment: .bottomTrailing
                    )
                }
                .blur(radius: blur)

                if colorScheme == .dark {
                    Color.black.opacity(0.85)
                }

                VisualEffectView(effect: UIBlurEffect(style: colorScheme == .dark ? .dark : .systemThickMaterial))
            }
            .ignoresSafeArea()
        }
    }
}
