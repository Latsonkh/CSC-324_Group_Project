//
//  CameraView.swift
//  ProjectP
//
//  Created by Caelan on 11/20/24.
//

import SwiftUI
import UIKit

struct CameraView: View {
    let onImageCaptured: (UIImage) -> Void

    let model = CameraManager()

    @Environment(\.dismiss) var dismiss
    @State private var capturedImage: UIImage?
    @State private var presentImageCropper: Bool = false

    init(onImageCaptured: @escaping (UIImage) -> Void) {
        self.onImageCaptured = onImageCaptured
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()

                    CameraPreviewView(model: model)
                        .ignoresSafeArea()

                    // controls
                    VStack {
                        Spacer()

                        Button {
                            Task {
                                let image = await model.capture()
                                if let image {
                                    capturedImage = cropImage(image)
                                    presentImageCropper = true
                                }
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .stroke(.white.opacity(0.6), lineWidth: 4)
                                    .frame(width: 68, height: 68)

                                Circle()
                                    .fill(.white)
                                    .frame(width: 60, height: 60)
                            }
                        }
                    }
                    .padding(.bottom, 20 + geometry.safeAreaInsets.bottom)
                }
            }
            .navigationDestination(isPresented: $presentImageCropper) {
                if let capturedImage {
                    ImageCropView(image: capturedImage) { croppedImage in
                        onImageCaptured(croppedImage)
                        dismiss()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CloseButton {
                        dismiss()
                    }
                }
            }
        }
    }

    // crop image to screen size (so it matches the camera view) and fix orientation
    func cropImage(_ image: UIImage) -> UIImage {
        let screenSize = UIScreen.main.bounds.size

        UIGraphicsBeginImageContextWithOptions(screenSize, false, UIScreen.main.scale)

        let imageAspect = image.size.width / image.size.height
        let screenAspect = screenSize.width / screenSize.height

        var drawRect: CGRect = CGRect(origin: .zero, size: screenSize)

        if imageAspect > screenAspect {
            let scaledWidth = screenSize.height * imageAspect
            drawRect.origin.x = (screenSize.width - scaledWidth) / 2
            drawRect.size.width = scaledWidth
        } else {
            let scaledHeight = screenSize.width / imageAspect
            drawRect.origin.y = (screenSize.height - scaledHeight) / 2
            drawRect.size.height = scaledHeight
        }

        image.draw(in: drawRect)

        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return croppedImage ?? image
    }
}
