//
//  ContentView.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/23/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = QRScannerViewModel()
    @State private var isShowScanner = false
    
    var body: some View {
        TabView {
            VStack {
                Button("Quét mã QR") {
                    isShowScanner = true
                }
                .font(.title)
                .padding()
                .sheet(isPresented: $isShowScanner) {
                    ScannerView { code in
                        viewModel.addToStory(code)
                        isShowScanner = false
                    }
                }
            }
            .tabItem {
                Label("Scan", systemImage: "qrcode.viewfinder")
            }
            HistoryView(viewModel: viewModel)
                .tabItem {
                    Label("Lịch sử", systemImage: "clock")
                }
        }
    }
}

#Preview {
    ContentView()
}
