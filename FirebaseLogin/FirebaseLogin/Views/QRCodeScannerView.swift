//
//  QRCodeScannerView.swift
//  FirebaseLogin
//
//  Created by Jose on 26/9/24.
//

import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewControllerRepresentable {
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView
        var completion: (Result<String, QRCodeScannerError>) -> Void

        init(parent: QRCodeScannerView, completion: @escaping (Result<String, QRCodeScannerError>) -> Void) {
            self.parent = parent
            self.completion = completion
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }

                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                completion(.success(stringValue))
            }
        }
    }

    var completion: (Result<String, QRCodeScannerError>) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, completion: completion)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            context.coordinator.completion(.failure(.noCameraAvailable))
            return viewController
        }

        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            context.coordinator.completion(.failure(.inputDeviceError))
            return viewController
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            context.coordinator.completion(.failure(.invalidInput))
            return viewController
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            context.coordinator.completion(.failure(.invalidOutput))
            return viewController
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        captureSession.startRunning()

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }

    enum QRCodeScannerError: Error {
        case noCameraAvailable
        case inputDeviceError
        case invalidInput
        case invalidOutput
    }
}
