//
//  QRGeneratorView.swift
//  QRScanner
//
//  Created by Nguyen Quang Minh on 8/30/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRGeneratorView: View {
    @Environment(\.dismiss) var dismiss
    @State private var text = ""
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                TextField("Enter text to encode", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if let image = generateQRCode(from: text) {
                    Image(uiImage: image)
                        .interpolation(.none)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Create QR Code")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let output = filter.outputImage,
           let cgimg = context.createCGImage(output.transformed(by: CGAffineTransform(scaleX: 10, y: 10)), from: output.extent) {
            return UIImage(cgImage: cgimg)
        }
        
        return nil
    }
}
