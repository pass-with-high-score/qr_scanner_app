//
//  QECodeScanner.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/23/25.
//

import SwiftUI

struct ScannerView: View {
    @StateObject private var scanner = QRCodeScanner()
    
    var onCodeScanned: (String) -> Void
    var body: some View {
        ZStack {
            CameraPreview(session: scanner)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Đưa mã QR vào khung")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .onReceive(scanner.$scannedCode.compactMap { $0 }) { code in
            onCodeScanned(code)
        }
        .onAppear {
            scanner.startScanning()
        }
        .onDisappear {
            scanner.stopScanning()
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var session: QRCodeScanner
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        if let previewLayer = session.getPreviewLayer() {
            previewLayer.frame = UIScreen.main.bounds
            view.layer.addSublayer(previewLayer)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
