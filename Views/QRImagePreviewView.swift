//
//  QRImagePreviewView.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/24/25.
//

import SwiftUI

struct QRImagePreviewView: View {
    let content: String
    
    var body: some View {
        VStack(spacing: 20) {
            if let image = generateQRCode(from: content) {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
            } else {
                Text("Không thể tạo mã QR")
            }
            
            Text(content)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}


#Preview {
    QRImagePreviewView(content: "Hello, World!")
}
