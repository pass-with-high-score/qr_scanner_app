//
//  HistoryView.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/23/25.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: QRScannerViewModel
    @State private var searchText = ""
    @State private var editMode: EditMode = .inactive
    
    var filteredHistory: [QRCodeItem] {
        if searchText.isEmpty {
            return viewModel.history
        } else {
            return viewModel.history.filter {
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredHistory) { item in
                    VStack(alignment: .leading) {
                        Text(item.content)
                            .font(.headline)
                        Text(
                            "Scanned at: \(DateFormatter.localizedString(from: item.scannedAt, dateStyle: .short, timeStyle: .short))"
                        )
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                }
                .onDelete(perform: viewModel.deleteItems)
                .onMove(perform: viewModel.moveItems)
            }
            .navigationTitle("Lịch sử QR")
            .searchable(text: $searchText, prompt: "Tìm mã QR...")
            .toolbar {
                EditButton()
            }
            .environment(\.editMode, $editMode)
        }
    }
}
