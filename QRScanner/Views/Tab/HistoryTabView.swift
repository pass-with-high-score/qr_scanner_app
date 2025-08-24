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
                        Text("label_no_results_found")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Text("label_try_a_different_search_term")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.history.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("title_no_qr_history_found")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Text("label_scan_a_qr_code_to_see_it_here")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
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
            .searchable(text: $searchText, prompt: "hint_find_qr_code")
            .navigationTitle("nav_qr_code_history")
            .sheet(item: $selectedQRForPreview) { item in
                QRImagePreviewView(content: item.value)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        showingClearConfirm = true
                    } label: {
                        Label("btn_clear_all", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
            .alert("alert_clear_all_history_title", isPresented: $showingClearConfirm) {
                Button("btn_cancel", role: .destructive) {
                    viewModel.clearHistory()
                }
                Button("btn_cancel", role: .cancel) { }
            } message: {
                Text("alert_clear_all_history_content")
            }
            .sheet(item: $shareContent) { item in
                ActivityView(activityItems: [item.value])
            }
        }
    }
}
