//
//  ContentView.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/23/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = QRScannerViewModel()
    
    var body: some View {
        TabView {
            ScanTabView(viewModel: viewModel)
            .tabItem {
                Label("Scan", systemImage: "qrcode.viewfinder")
            }
            HistoryTabView(viewModel: viewModel)
                .tabItem {
                    Label("Lịch sử", systemImage: "clock")
                }
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    ContentView()
}
