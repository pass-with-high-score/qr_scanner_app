//
//  HistoryView.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/23/25.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: QRScannerViewModel
    var body: some View {
        NavigationView {
            List(viewModel.history, id: \.self.id) { item in
                VStack(alignment: .leading) {
                    Text(item.content)
                        .font(.headline)
                    Text(
                        "Scanned at: \(DateFormatter.localizedString(from: item.scannedAt, dateStyle: .short, timeStyle: .short))"
                    )
                }
            }
        }
        .navigationTitle("Lịch sử QR")
    }
}
