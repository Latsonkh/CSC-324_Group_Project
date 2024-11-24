//
//  ImageManager.swift
//  ProjectP
//
//  Created by Khameron Latson on 11/22/24.
//

@preconcurrency import Vision
import UIKit
import SwiftUI

class ImageManager {
    enum ExtractionError: Error {
        case missingCGImage
        case textRecognitionFailed(Error)
        case requestHandlerFailed(Error)
    }

    static func extractText(from image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw ExtractionError.missingCGImage
        }

        return try await withCheckedThrowingContinuation { continuation in
            // Create a request for recognizing text
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    continuation.resume(throwing: ExtractionError.textRecognitionFailed(error))
                }

                // Extract recognized text from the results
                let recognizedText = request.results?
                    .compactMap { $0 as? VNRecognizedTextObservation }
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: " ") ?? ""

                continuation.resume(returning: recognizedText)
            }

            // Set the recognition level for better accuracy
            request.recognitionLevel = .accurate

            // Perform the request on the image
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            Task.detached {
                do {
                    try requestHandler.perform([request])
                } catch {
                    continuation.resume(throwing: ExtractionError.requestHandlerFailed(error))
                }
            }
        }
    }
}
