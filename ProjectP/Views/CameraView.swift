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
            ZStack {
                CameraPreviewView(model: model)
                    .ignoresSafeArea()

                // controls
                VStack {
                    Spacer()

                    Button {
                        Task {
                            let image = await model.capture()
                            if let image {
                                capturedImage = image
                                presentImageCropper = true
                            }
                        }
                    } label: {
                        Circle()
                            .fill(.white)
                            .frame(width: 60, height: 60)
                    }
                }
                .padding(.bottom, 40)
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
}
