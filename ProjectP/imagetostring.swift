//
//  imagetostring.swift
//  ProjectP
//
//  Created by Khameron Latson on 11/22/24.
//

@preconcurrency import Vision
import UIKit
import SwiftUI

func extractText(from image: UIImage, completion: @escaping @Sendable(String) -> Void) {
    // Convert the UIImage to a CGImage
    guard let cgImage = image.cgImage else {
        completion("Failed to convert UIImage to CGImage.")
        return
    }
    
    // Create a request for recognizing text
    let request = VNRecognizeTextRequest { (request, error) in
        if let error = error {
            completion("Error during text recognition: \(error.localizedDescription)")
            return
        }
        
        // Extract recognized text from the results
        let recognizedText = request.results?
            .compactMap { $0 as? VNRecognizedTextObservation }
            .compactMap { $0.topCandidates(1).first?.string }
            .joined(separator: " ") ?? ""
        
        completion(recognizedText)
    }
    
    // Set the recognition level for better accuracy
    request.recognitionLevel = .accurate
    
    // Perform the request on the image
    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    DispatchQueue.global(qos: .userInitiated).async {
        do {
            try requestHandler.perform([request])
        } catch {
            completion("Failed to perform text recognition: \(error.localizedDescription)")
        }
    }
}
