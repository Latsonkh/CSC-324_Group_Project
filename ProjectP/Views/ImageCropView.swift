//
//  ImageCropView.swift
//  ProjectP
//
//  Created by Caelan on 11/22/24.
//

import SwiftUI

enum DragHandle {
    case topLeft, topRight, bottomLeft, bottomRight
    case top, bottom, left, right
}

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

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(50)
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
                                    .insetBy(dx: 50, dy: 50)

                                    viewSize = geometry.size
                                    imageSize = image.size
                                    cropRect = imageFrame
                                }
                        }
                    )

                // dim outside of the crop rectangle
                Path { path in
                    path.addRect(geometry.frame(in: .global))
                    path.addRoundedRect(
                        in: cropRect,
                        cornerRadii: .init(topLeading: 5, bottomLeading: 5, bottomTrailing: 5, topTrailing: 5)
                    )
                }
                .fill(Color.black.opacity(0.5), style: FillStyle(eoFill: true))

                // draggable area
                if cropRect.width > 0 {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white.opacity(0.001))
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

                CropRectangleHandles(rect: cropRect, updateCropRect: updateCropRect)

                // draggable edge gestures
                if cropRect.width > 0 {
                    Group {
                        // top
                        Rectangle()
                            .fill(Color.white.opacity(0.001))
                            .frame(width: cropRect.width - 20, height: 20)
                            .position(x: cropRect.midX, y: cropRect.minY)
                            .gesture(DragGesture().onChanged { updateCropRect(with: $0.location, for: .top) })

                        // bottom
                        Rectangle()
                            .fill(Color.white.opacity(0.001))
                            .frame(width: cropRect.width - 20, height: 20)
                            .position(x: cropRect.midX, y: cropRect.maxY)
                            .gesture(DragGesture().onChanged { updateCropRect(with: $0.location, for: .bottom) })

                        // left
                        Rectangle()
                            .fill(Color.white.opacity(0.001))
                            .frame(width: 20, height: cropRect.height - 20)
                            .position(x: cropRect.minX, y: cropRect.midY)
                            .gesture(DragGesture().onChanged { updateCropRect(with: $0.location, for: .left) })

                        // right
                        Rectangle()
                            .fill(Color.white.opacity(0.001))
                            .frame(width: 20, height: cropRect.height - 20)
                            .position(x: cropRect.maxX, y: cropRect.midY)
                            .gesture(DragGesture().onChanged { updateCropRect(with: $0.location, for: .right) })
                    }
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

    private func updateCropRect(with location: CGPoint, for handle: DragHandle) {
        let constrainedLocation = CGPoint(
            x: max(imageFrame.minX, min(location.x, imageFrame.maxX)),
            y: max(imageFrame.minY, min(location.y, imageFrame.maxY))
        )

        let minSize: CGFloat = 50
        var newRect = cropRect

        switch handle {
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
            case .top:
                newRect.origin.y = min(constrainedLocation.y, cropRect.maxY - minSize)
                newRect.size.height = cropRect.maxY - newRect.origin.y
            case .bottom:
                newRect.size.height = max(min(constrainedLocation.y - cropRect.minY, imageFrame.maxY - cropRect.minY), minSize)
            case .left:
                newRect.origin.x = min(constrainedLocation.x, cropRect.maxX - minSize)
                newRect.size.width = cropRect.maxX - newRect.origin.x
            case .right:
                newRect.size.width = max(min(constrainedLocation.x - cropRect.minX, imageFrame.maxX - cropRect.minX), minSize)
        }

        cropRect = newRect
    }

    private func cropImage() -> UIImage? {
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

private struct CropRectangleHandles: View {
    let rect: CGRect

    let updateCropRect: (CGPoint, DragHandle) -> Void

    var body: some View {
        ZStack {
            // corner handles (with dragging)
            Group {
                cornerHandle(at: rect.origin, orientation: .topLeft)
                    .gesture(DragGesture().onChanged { updateCropRect($0.location, .topLeft) })
                cornerHandle(at: CGPoint(x: rect.maxX, y: rect.minY), orientation: .topRight)
                    .gesture(DragGesture().onChanged { updateCropRect($0.location, .topRight) })
                cornerHandle(at: CGPoint(x: rect.minX, y: rect.maxY), orientation: .bottomLeft)
                    .gesture(DragGesture().onChanged { updateCropRect($0.location, .bottomLeft) })
                cornerHandle(at: CGPoint(x: rect.maxX, y: rect.maxY), orientation: .bottomRight)
                    .gesture(DragGesture().onChanged { updateCropRect($0.location, .bottomRight) })
            }

            // edge handles
            Group {
                // top
                edgeHandle(at: CGPoint(x: rect.midX, y: rect.minY), isVertical: false)
                // bottom
                edgeHandle(at: CGPoint(x: rect.midX, y: rect.maxY), isVertical: false)
                // left
                edgeHandle(at: CGPoint(x: rect.minX, y: rect.midY), isVertical: true)
                // right
                edgeHandle(at: CGPoint(x: rect.maxX, y: rect.midY), isVertical: true)
            }
        }
    }

    private enum CornerOrientation: CaseIterable {
        case topLeft, topRight, bottomLeft, bottomRight
    }

    private func cornerHandle(at point: CGPoint, orientation: CornerOrientation) -> some View {
        let lineLength: CGFloat = 20
        let lineWidth: CGFloat = 2
        let cornerRadius: CGFloat = 5

        return ZStack {
            // make the view bigger so that it's easier to grab
            Rectangle()
                .fill(Color.white.opacity(0.001))
                .frame(width: lineLength * 2, height: lineLength * 2)
                .offset(x: -lineLength, y: -lineLength)

            Path { path in
                switch orientation {
                    case .topLeft:
                        path.move(to: CGPoint(x: lineLength, y: 0))
                        path.addArc(
                            center: CGPoint(x: cornerRadius, y: cornerRadius),
                            radius: cornerRadius,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(180),
                            clockwise: true
                        )
                        path.addLine(to: CGPoint(x: 0, y: lineLength))

                    case .topRight:
                        path.move(to: CGPoint(x: -lineLength, y: 0))
                        path.addArc(
                            center: CGPoint(x: -cornerRadius, y: cornerRadius),
                            radius: cornerRadius,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(0),
                            clockwise: false)
                        path.addLine(to: CGPoint(x: 0, y: lineLength))

                    case .bottomLeft:
                        path.move(to: CGPoint(x: lineLength, y: 0))
                        path.addArc(
                            center: CGPoint(x: cornerRadius, y: -cornerRadius),
                            radius: cornerRadius,
                            startAngle: .degrees(90),
                            endAngle: .degrees(180),
                            clockwise: false)
                        path.addLine(to: CGPoint(x: 0, y: -lineLength))

                    case .bottomRight:
                        path.move(to: CGPoint(x: -lineLength, y: 0))
                        path.addArc(
                            center: CGPoint(x: -cornerRadius, y: -cornerRadius),
                            radius: cornerRadius,
                            startAngle: .degrees(90),
                            endAngle: .degrees(0),
                            clockwise: true
                        )
                        path.addLine(to: CGPoint(x: 0, y: -lineLength))
                }
            }
            .stroke(Color.white, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .frame(width: lineLength * 2, height: lineLength * 2)
        }
        .position(CGPoint(x: point.x + lineLength, y: point.y + lineLength))
    }

    private func edgeHandle(at point: CGPoint, isVertical: Bool) -> some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(.white)
            .frame(width: isVertical ? 2 : 25, height: isVertical ? 25 : 2)
            .position(point)
    }
}
