//
//  QRImagePreviewView.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/24/25.
//

import SwiftUI

struct IdentifiableUIImage: Identifiable {
    let id = UUID()
    let image: UIImage
}

struct QRImagePreviewView: View {
    let content: String
    @Environment(\.dismiss) var dismiss
    @State private var showShareSheet = false
    @State private var qrImage: UIImage? = nil
    @State private var shareImage: IdentifiableUIImage?
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if let image = generateQRCode(from: content) {
                    Image(uiImage: image)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 280, maxHeight: 280)
                        .onAppear {
                            qrImage = image
                        }
                } else {
                    Text("label_can_not_generate_qr")
                        .foregroundColor(.red)
                }
                
                ZStack {
                    Color(UIColor.secondarySystemBackground)
                        .ignoresSafeArea()
                    
                    GeometryReader { geometry in
                        ScrollView {
                            VStack {
                                Text(content)
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .minimumScaleFactor(0.5)
                            }
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.height,
                                alignment: .center
                            )
                        }
                    }
                }
                .frame(height: 150)
                .cornerRadius(12)
                
                Button {
                    if let image = qrImage {
                        shareImage = IdentifiableUIImage(image: image)
                    }
                    
                } label: {
                    Label("btn_share_qr_image", systemImage: "square.and.arrow.up")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .disabled(qrImage == nil)
                
                Spacer()
            }
            .padding()
            .navigationTitle("nav_qr_image_preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("btn_close") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(item: $shareImage) { item in
            ActivityView(activityItems: [item.image])
        }
        
        
    }
}


#Preview {
    QRImagePreviewView(content: "Hello, World!")
}
