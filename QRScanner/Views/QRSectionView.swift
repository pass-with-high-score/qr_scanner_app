//
//  QRSectionView.swift
//  QRScanner
//
//  Created by Nguyen Quang Minh on 8/24/25.
//

import SwiftUI

struct SectionView: View {
    let section: QRDaySection
    @ObservedObject var viewModel: QRScannerViewModel
    @Binding var shareContent: IdentifiableString?
    @Binding var selectedQRForPreview: IdentifiableString?
    @Binding var showShareSheet: Bool
    
    var body: some View {
        Section(
            header: Text(section.date, style: .date)
                .font(.headline)
                .foregroundColor(.primary)
        ) {
            ForEach(section.items) { item in
                VStack(alignment: .leading) {
                    Text(item.content)
                        .font(.headline)
                    Text(
                        "Scanned at: \(DateFormatter.localizedString(from: item.scannedAt, dateStyle: .short, timeStyle: .short))"
                    )
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = item.content
                    } label: {
                        Label("Sao chép", systemImage: "doc.on.doc")
                    }
                    
                    if let url = URL(string: item.content), UIApplication.shared.canOpenURL(url) {
                        Button {
                            UIApplication.shared.open(url)
                        } label: {
                            Label("Mở trong Safari", systemImage: "safari")
                        }
                    }
                    
                    Button {
                        selectedQRForPreview = IdentifiableString(value: item.content)
                    } label: {
                        Label("Xem mã QR", systemImage: "qrcode")
                    }
                    
                    Button {
                        shareContent = IdentifiableString(value: item.content)
                        showShareSheet = true
                    } label: {
                        Label("Chia sẻ", systemImage: "square.and.arrow.up")
                    }
                    
                    Button(role: .destructive) {
                        viewModel.deleteByIDs([item.id])
                    } label: {
                        Label("Xoá", systemImage: "trash")
                    }
                }
            }
            .onDelete(perform:viewModel.deleteItems)
        }
    }
}
