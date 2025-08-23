//
//  ScanTabView.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/24/25.
//

import SwiftUI

struct ScanTabView: View {
    @State private var isShowScanner = false
    @ObservedObject var viewModel: QRScannerViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "qrcode.viewfinder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.accentColor)
                    .padding()
                    .shadow(radius: 10)
                
                Text("Quét mã QR để lưu vào lịch sử.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Button {
                    isShowScanner = true
                } label: {
                    Label("Bắt đầu quét", systemImage: "camera.viewfinder")
                        .font(.title3)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                
                Spacer()
            }
            .sheet(isPresented: $isShowScanner) {
                ScannerView { code in
                    viewModel.addToStory(code)
                    isShowScanner = false
                }
            }
            .navigationTitle("Quét mã QR")
        }
    }
}
