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
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.accentColor)
                            .padding()
                        
                        Text("title_scan_qr_code")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("subtitle_scan_qr_code")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                    )
                    .padding(.horizontal)
                    
                    Button(action: {
                        isShowScanner = true
                    }) {
                        VStack(spacing: 4) {
                            Label("btn_start_scanning", systemImage: "camera.viewfinder")
                                .font(.headline)
                            
                            Text("subtitle_open_camera_to_scan_qr_code")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 80)
            }
            .sheet(isPresented: $isShowScanner) {
                ScannerView { code in
                    viewModel.addToStory(code)
                    isShowScanner = false
                }
            }
            .navigationTitle("nav_scan_qr_code")
        }
    }
}
