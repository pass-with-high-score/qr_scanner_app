//
//  QRImagePicker.swift
//  QRScanner
//
//  Created by Nguyen Quang Minh on 8/30/25.
//

import SwiftUI
import PhotosUI
import VisionKit

struct QRImagePicker: UIViewControllerRepresentable {
    var onComplete: (String?) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onComplete: onComplete)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let onComplete: (String?) -> Void
        
        init(onComplete: @escaping (String?) -> Void) {
            self.onComplete = onComplete
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let result = results.first else {
                onComplete(nil)
                return
            }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { (reading, error) in
                guard let image = reading as? UIImage else {
                    self.onComplete(nil)
                    return
                }
                
                self.detectQRCode(from: image)
            }
        }
        
        private func detectQRCode(from image: UIImage) {
            guard let ciImage = CIImage(image: image) else {
                onComplete(nil)
                return
            }
            
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
            
            if let features = detector?.features(in: ciImage), let qrFeature = features.first as? CIQRCodeFeature {
                onComplete(qrFeature.messageString)
            } else {
                onComplete(nil)
            }
        }
    }
}
