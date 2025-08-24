//
//  QECodeScanner.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/23/25.
//

import SwiftUI
import AVFoundation

struct ScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var scanner = QRCodeScanner()
    @State private var laserOffset: CGFloat = -110
    @State private var movingDown = true
    @State private var laserTimer: Timer?
    @State private var showSuccessAlert = false
    @State private var scannedCodeTemp: String?
    
    var onCodeScanned: (String) -> Void
    
    var body: some View {
        ZStack {
            // Camera
            CameraPreview(session: scanner)
                .ignoresSafeArea()
            
            GeometryReader { geo in
                let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                ZStack {
                    // Mask
                    Color.black.opacity(0.6)
                        .mask {
                            Rectangle()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .frame(width: 240, height: 240)
                                        .blendMode(.destinationOut)
                                        .position(center)
                                )
                        }
                        .compositingGroup()
                        .ignoresSafeArea()
                    
                    // Border, QR image & Laser
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 240, height: 240)
                        
                        Image(systemName:"qrcode.viewfinder")
                            .resizable()
                            .foregroundColor(.white)
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                        
                        // Moving laser
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: 220, height: 2)
                            .offset(y: laserOffset)
                            .animation(.linear(duration: 1), value: laserOffset)
                    }
                    .frame(width: 240, height: 240)
                    .position(center)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .onAppear {
                    laserTimer =  Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        withAnimation {
                            if movingDown {
                                laserOffset = 110
                            } else {
                                laserOffset = -110
                            }
                            movingDown.toggle()
                        }
                    }
                }
            }
            .ignoresSafeArea()
            
            // Text hướng dẫn
            VStack {
                HStack {
                    Button {
                        scanner.toggleTorch()
                    } label: {
                        Image(systemName: "flashlight.on.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
                Spacer()
                
                Text("title_place_the_qr_code_inside_the_frame")
                    .foregroundColor(.white)
                    .padding(.top, 16)
                    .font(.headline)
                
            }
        }
        .onReceive(scanner.$scannedCode.compactMap { $0 }) { code in
            scannedCodeTemp = code
            showSuccessAlert = true
            scanner.stopScanning()
            laserTimer?.invalidate()
            
            // vibrate on success
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        .onAppear {
            scanner.startScanning()
        }
        .onDisappear {
            scanner.stopScanning()
        }
        .alert("aleart_scanned_successfully", isPresented: $showSuccessAlert, presenting: scannedCodeTemp) { code in
            Button("btn_save") {
                onCodeScanned(code)
                dismiss()
            }
            Button("btn_copy") {
                UIPasteboard.general.string = code
                dismiss()
            }
            if let url = URL(string: code), UIApplication.shared.canOpenURL(url) {
                Button("btn_open_in_safari") {
                    UIApplication.shared.open(url)
                    dismiss()
                }
            }
            Button("btn_cancel", role: .cancel) {
                dismiss()
            }
        } message: { code in
            Text("label_content \(code)")
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
