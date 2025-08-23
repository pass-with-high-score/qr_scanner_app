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
    @State private var selection = Set<UUID>()
    @State private var showingClearConfirm = false
    
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
            Group {
                if !searchText.isEmpty && filteredHistory.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No results found")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Text("Try a different search term.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.history.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No QR history found")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Text("Scan a QR code to see it here.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(selection: $selection) {
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
                    }
                    .toolbar {
                        EditButton()
                        if !selection.isEmpty {
                            Button {
                                viewModel.deleteByIDs(selection)
                                selection.removeAll()
                            } label: {
                                Label("Delete (\(selection.count))", systemImage: "trash")
                            }
                        }
                        if editMode == .active {
                            Button {
                                selection = Set(viewModel.history.map { $0.id })
                            } label: {
                                Label("Select All", systemImage: "checkmark.circle")
                            }
                            Button {
                                showingClearConfirm = true
                            } label: {
                                Label("Clear All", systemImage: "xmark.circle")
                            }
                            .alert("Xác nhận xoá toàn bộ?", isPresented: $showingClearConfirm) {
                                Button("Xoá", role: .destructive) {
                                    viewModel.clearHistory()
                                    selection.removeAll()
                                }
                                Button("Huỷ", role: .cancel) { }
                            }
                        }
                    }
                    .environment(\.editMode, $editMode)
                }
            }
            .searchable(text: $searchText, prompt: "Tìm mã QR...")
            .navigationTitle("Lịch sử QR")
        }
    }
}
