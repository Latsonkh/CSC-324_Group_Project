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
    static func extractText(from image: UIImage) async -> String {
        guard let cgImage = image.cgImage else {
            return "Failed to convert UIImage to CGImage."
        }

        return await withCheckedContinuation { continuation in
            // Create a request for recognizing text
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    continuation.resume(returning: "Error during text recognition: \(error.localizedDescription)")
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
                    continuation.resume(returning: "Failed to perform text recognition: \(error.localizedDescription)")
                }
            }
        }
    }
}
