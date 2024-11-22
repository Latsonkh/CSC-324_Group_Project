//
//  CameraManager.swift
//  ProjectP
//
//  Created by Caelan on 11/22/24.
//

import UIKit
@preconcurrency import AVFoundation

@MainActor
class CameraManager {
    private var captureSession = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var mainCamera: AVCaptureDevice?
    private var backCamera: AVCaptureDevice?
    private var currentDevice: AVCaptureDevice?

    private var delegate: PhotoCaptureDelegate?

    init() {
        // capture session
        captureSession.sessionPreset = AVCaptureSession.Preset.photo

        // get front and back camera handles
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
            mediaType: AVMediaType.video,
            position: AVCaptureDevice.Position.unspecified
        )

        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                mainCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                backCamera = device
            }
        }

        currentDevice = mainCamera

        // set output format
        photoOutput.setPreparedPhotoSettingsArray(
            [AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])],
            completionHandler: nil
        )
        captureSession.addOutput(photoOutput)

        // if there are no cameras, we can't set up an input
        guard let currentDevice else { return }

        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print("failed to initialize camera input")
        }
    }

    func start() {
        Task.detached {
            await self.captureSession.startRunning()
        }
    }

    func stop() {
        Task.detached {
            await self.captureSession.stopRunning()
        }
    }

    func capture() async -> UIImage? {
        await withCheckedContinuation { continuation in
            delegate = PhotoCaptureDelegate { image in
                continuation.resume(returning: image)
            }
            let settings = AVCapturePhotoSettings()
            settings.flashMode = .auto
            photoOutput.capturePhoto(with: settings, delegate: delegate!)
        }
    }

    func setupPreviewLayer(on uiView: UIView) {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait

        cameraPreviewLayer.frame = uiView.frame
        uiView.layer.insertSublayer(cameraPreviewLayer, at: 0)
    }
}

class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    private let completion: (UIImage?) -> Void

    init(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
    }

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        if let error {
            print("Error capturing photo: \(error.localizedDescription)")
            completion(nil)
            return
        }

        guard
            let imageData = photo.fileDataRepresentation(),
            let image = UIImage(data: imageData)
        else {
            completion(nil)
            return
        }

        completion(image)
    }
}
