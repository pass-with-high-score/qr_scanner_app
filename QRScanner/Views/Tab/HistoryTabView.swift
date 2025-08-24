//
//  HistoryView.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/23/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct HistoryTabView: View {
    @ObservedObject var viewModel: QRScannerViewModel
    @State private var searchText = ""
    @State private var showingClearConfirm = false
    @State private var showShareSheet = false
    @State private var shareContent: IdentifiableString?
    @State private var selectedQRForPreview: IdentifiableString?
    
    var filteredDaySections: [QRDaySection] {
        let filtered = searchText.isEmpty
        ? viewModel.history
        : viewModel.history.filter {
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
        
        let grouped = Dictionary(grouping: filtered, by: { Calendar.current.startOfDay(for: $0.scannedAt) })
        
        return grouped.map { (date, items) in
            QRDaySection(date: date, items: items)
        }
        .sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if !searchText.isEmpty && filteredDaySections.isEmpty {
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
                    List {
                        ForEach(filteredDaySections) { section in
                            SectionView(
                                section: section,
                                viewModel: viewModel,
                                shareContent: $shareContent,
                                selectedQRForPreview: $selectedQRForPreview,
                                showShareSheet: $showShareSheet
                            )
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Tìm mã QR...")
            .navigationTitle("Lịch sử QR")
            .sheet(item: $selectedQRForPreview) { item in
                QRImagePreviewView(content: item.value)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        showingClearConfirm = true
                    } label: {
                        Label("Clear All", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
            .alert("Clear all history?", isPresented: $showingClearConfirm) {
                Button("Clear", role: .destructive) {
                    viewModel.clearHistory()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will remove all QR history. This action cannot be undone.")
            }
            .sheet(item: $shareContent) { item in
                ActivityView(text: item.value)
            }
        }
    }
}
