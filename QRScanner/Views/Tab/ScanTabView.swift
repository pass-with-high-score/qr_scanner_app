//
//  ScanTabView.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/24/25.
//

import SwiftUI
import PhotosUI

struct ScanTabView: View {
    @State private var isShowScanner = false
    @State private var isShowImagePicker = false
    @State private var isShowQRGenerator = false
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
                            .frame(width: 48, height: 48)
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
                            .shadow(radius: 5)
                    )
                    .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            isShowScanner = true
                        }) {
                            Label("btn_start_scanning", systemImage: "camera.viewfinder")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                        
                        Button(action: {
                            isShowImagePicker = true
                        }) {
                            Label("btn_scan_from_image", systemImage: "photo")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                        
                        Button(action: {
                            isShowQRGenerator = true
                        }) {
                            Label("btn_create_qr", systemImage: "qrcode")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 80)
            }
            .sheet(isPresented: $isShowScanner) {
                ScannerView { code in
                    viewModel.addToStory(code)
                    isShowScanner = false
                }
            }
            .sheet(isPresented: $isShowImagePicker) {
                QRImagePicker { code in
                    DispatchQueue.main.async {
                        if let code = code {
                            viewModel.addToStory(code)
                        }
                        isShowImagePicker = false
                    }
                }
            }
            .sheet(isPresented: $isShowQRGenerator) {
                QRGeneratorView()
            }
            .navigationTitle("nav_scan_qr_code")
        }
    }
}
