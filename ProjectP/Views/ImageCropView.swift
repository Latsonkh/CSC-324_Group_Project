//
//  ImageCropView.swift
//  ProjectP
//
//  Created by Caelan on 11/22/24.
//

import SwiftUI

struct ImageCropView: View {
    let image: UIImage
    let onCrop: (UIImage) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var cropRect: CGRect = .zero
    @State private var viewSize: CGSize = .zero
    @State private var imageSize: CGSize = .zero
    @State private var imageFrame: CGRect = .zero
    @State private var isDragging = false
    @State private var dragStart: CGPoint = .zero
    @State private var initialCropRect: CGRect = .zero

    private enum DragCorner {
        case topLeft, topRight, bottomLeft, bottomRight
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .background(
                        GeometryReader { imageGeometry in
                            Color.clear
                                .onAppear {
                                    let frame = imageGeometry.frame(in: .local)
                                    let globalFrame = geometry.frame(in: .global)

                                    imageFrame = CGRect(
                                        x: 0,
                                        y: globalFrame.height / 2 - frame.height / 2,
                                        width: frame.width,
                                        height: frame.height
                                    )

                                    viewSize = geometry.size
                                    imageSize = CGSize(
                                        width: image.size.width,
                                        height: image.size.height
                                    )

                                    // inset initial crop rect
                                    let inset = frame.width * 0.1
                                    cropRect = imageFrame.insetBy(dx: inset, dy: inset)
                                }
                                .ignoresSafeArea()
                        }
                    )

                // dim outside of the crop rectangle
                Path { path in
                    path.addRect(geometry.frame(in: .local))
                    path.addRect(cropRect)
                }
                .fill(Color.black.opacity(0.5), style: FillStyle(eoFill: true))

                // draggable area
                if cropRect.width > 0 {
                    Rectangle()
                        .fill(Color.white.opacity(0.001)) // Nearly invisible but still interactive
                        .frame(width: cropRect.width - 4, height: cropRect.height - 4)
                        .position(x: cropRect.midX, y: cropRect.midY)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if !isDragging {
                                        isDragging = true
                                        dragStart = value.location
                                        initialCropRect = cropRect
                                    }
                                    let translation = CGPoint(
                                        x: value.location.x - dragStart.x,
                                        y: value.location.y - dragStart.y
                                    )
                                    moveCropRect(by: translation)
                                }
                                .onEnded { _ in
                                    isDragging = false
                                }
                        )
                }

                // crop rectangle outline
                Rectangle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: cropRect.width, height: cropRect.height)
                    .position(x: cropRect.midX, y: cropRect.midY)

                // corners
                Group {
                    cornerHandle(at: cropRect.origin, corner: .topLeft)
                    cornerHandle(at: CGPoint(x: cropRect.maxX, y: cropRect.minY), corner: .topRight)
                    cornerHandle(at: CGPoint(x: cropRect.minX, y: cropRect.maxY), corner: .bottomLeft)
                    cornerHandle(at: CGPoint(x: cropRect.maxX, y: cropRect.maxY), corner: .bottomRight)
                }
            }
            .compositingGroup()
            .ignoresSafeArea()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    if let croppedImage = cropImage() {
                        onCrop(croppedImage)
                        dismiss()
                    }
                }
            }
        }
    }

    private func cornerHandle(at position: CGPoint, corner: DragCorner) -> some View {
        Circle()
            .fill(Color.white)
            .frame(width: 20, height: 20)
            .position(position)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        updateCropRect(with: value.location, for: corner)
                    }
            )
    }

    private func moveCropRect(by translation: CGPoint) {
        var newRect = initialCropRect.offsetBy(dx: translation.x, dy: translation.y)

        // constrain to image bounds
        if newRect.minX < imageFrame.minX {
            newRect.origin.x = imageFrame.minX
        }
        if newRect.maxX > imageFrame.maxX {
            newRect.origin.x = imageFrame.maxX - newRect.width
        }
        if newRect.minY < imageFrame.minY {
            newRect.origin.y = imageFrame.minY
        }
        if newRect.maxY > imageFrame.maxY {
            newRect.origin.y = imageFrame.maxY - newRect.height
        }

        cropRect = newRect
    }

    private func updateCropRect(with location: CGPoint, for corner: DragCorner) {
        let constrainedLocation = CGPoint(
            x: max(imageFrame.minX, min(location.x, imageFrame.maxX)),
            y: max(imageFrame.minY, min(location.y, imageFrame.maxY))
        )

        let minSize: CGFloat = 50
        var newRect = cropRect

        switch corner {
        case .topLeft:
            newRect.origin.x = min(constrainedLocation.x, cropRect.maxX - minSize)
            newRect.origin.y = min(constrainedLocation.y, cropRect.maxY - minSize)
            newRect.size.width = cropRect.maxX - newRect.origin.x
            newRect.size.height = cropRect.maxY - newRect.origin.y
        case .topRight:
            newRect.origin.y = min(constrainedLocation.y, cropRect.maxY - minSize)
            newRect.size.width = max(min(constrainedLocation.x - cropRect.minX, imageFrame.maxX - cropRect.minX), minSize)
            newRect.size.height = cropRect.maxY - newRect.origin.y
        case .bottomLeft:
            newRect.origin.x = min(constrainedLocation.x, cropRect.maxX - minSize)
            newRect.size.width = cropRect.maxX - newRect.origin.x
            newRect.size.height = max(min(constrainedLocation.y - cropRect.minY, imageFrame.maxY - cropRect.minY), minSize)
        case .bottomRight:
            newRect.size.width = max(min(constrainedLocation.x - cropRect.minX, imageFrame.maxX - cropRect.minX), minSize)
            newRect.size.height = max(min(constrainedLocation.y - cropRect.minY, imageFrame.maxY - cropRect.minY), minSize)
        }

        cropRect = newRect
    }

    private func cropImage() -> UIImage? {
        // fix image orientation
        let image = {
            if self.image.imageOrientation != .up {
                UIGraphicsBeginImageContextWithOptions(self.image.size, false, self.image.scale)
                var rect = CGRect.zero
                rect.size = self.image.size
                self.image.draw(in: rect)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return image ?? self.image
            } else {
                return self.image
            }
        }()

        guard let cgImage = image.cgImage else { return nil }

        let scale = CGFloat(cgImage.height) / imageFrame.height
        let imageX = (cropRect.minX - imageFrame.minX) * scale
        let imageY = (cropRect.minY - imageFrame.minY) * scale
        let imageWidth = cropRect.width * scale
        let imageHeight = cropRect.height * scale

        let cropZone = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)

        guard let cgImage = cgImage.cropping(to: cropZone) else { return nil }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: .up)
    }
}
