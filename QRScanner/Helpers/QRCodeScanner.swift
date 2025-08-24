//
//  QRCodeScanner.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/23/25.
//

import AVFoundation
import SwiftUI
import CoreImage.CIFilterBuiltins
import UIKit

enum CameraPosition {
    case front, back
}

final class QRCodeScanner: NSObject, ObservableObject {
    @Published var scannedCode: String?
    
    private var session: AVCaptureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var currentCameraPosition: CameraPosition = .back
    
    override init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoInput) else {
            print("❌ Không thể thêm input")
            return
        }
        
        session.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = .resizeAspectFill
    }
    
    func startScanning() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
    
    
    func stopScanning() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.stopRunning()
        }
    }
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        return previewLayer
    }
    
    func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = device.torchMode == .on ? .off : .on
            device.unlockForConfiguration()
        } catch {
            print("⚠️ Lỗi bật đèn flash: \(error)")
        }
    }
    
    func switchCamera() {
        session.beginConfiguration()
        
        // Remove current input
        if let currentInput = session.inputs.first as? AVCaptureDeviceInput {
            session.removeInput(currentInput)
        }
        
        // Get new camera
        let newPosition: AVCaptureDevice.Position = currentCameraPosition == .back ? .front : .back
        guard let newCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition),
              let newInput = try? AVCaptureDeviceInput(device: newCamera),
              session.canAddInput(newInput) else {
            session.commitConfiguration()
            return
        }
        
        session.addInput(newInput)
        currentCameraPosition = currentCameraPosition == .back ? .front : .back
        session.commitConfiguration()
    }

}

extension QRCodeScanner: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           metadataObject.type == .qr,
           let code = metadataObject.stringValue {
            scannedCode = code
            stopScanning()
        }
    }
}


func generateQRCode(from string: String) -> UIImage? {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    let data = Data(string.utf8)
    filter.setValue(data, forKey: "inputMessage")
    
    if let outputImage = filter.outputImage {
        // Scale lên để nét không bị mờ
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = outputImage.transformed(by: transform)
        
        if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
            return UIImage(cgImage: cgImage)
        }
    }
    
    return nil
}
