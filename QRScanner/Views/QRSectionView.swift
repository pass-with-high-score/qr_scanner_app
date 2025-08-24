//
//  QRSectionView.swift
//  QRScanner
//
//  Created by Nguyen Quang Minh on 8/24/25.
//

import SwiftUI
import UIKit
import Contacts
import ContactsUI

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
                let contentType = QRContentType.detect(from: item.content)
                
                VStack(alignment: .leading, spacing: 6) {
                    // Hiển thị tiêu đề theo loại
                    Text(displayTitle(for: contentType))
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    // Hiển thị nội dung
                    Text(item.content)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    // Thời gian quét
                    Text("subtitle_scanned_at \(DateFormatter.localizedString(from: item.scannedAt, dateStyle: .short, timeStyle: .short))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .contextMenu {
                    // Copy
                    Button {
                        UIPasteboard.general.string = item.content
                    } label: {
                        Label("label_copy", systemImage: "doc.on.doc")
                    }
                    
                    // Action theo loại QR
                    switch contentType {
                    case .url(let url):
                        Button {
                            UIApplication.shared.open(url)
                        } label: {
                            Label("label_open_in_safari", systemImage: "safari")
                        }
                        
                    case .email(let email):
                        Button {
                            if let url = URL(string: "mailto:\(email)") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Label("label_send_email", systemImage: "envelope")
                        }
                        
                    case .phone(let phone):
                        Button {
                            if let url = URL(string: "tel:\(phone)") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Label("label_call", systemImage: "phone")
                        }
                        
                    case .wifi(let config):
                        Button {
                            // Có thể hiển thị alert, sheet hoặc custom UI cấu hình WiFi
                            showWiFiConfig(config)
                        } label: {
                            Label("Hiển thị cấu hình WiFi", systemImage: "wifi")
                        }
                        
                    case .vcard(let vcard):
                        Button {
                            addToContacts(vcard: vcard)
                        } label: {
                            Label("label_add_to_contact", systemImage: "person.crop.circle.badge.plus")
                        }
                        
                    case .text:
                        EmptyView()
                    }
                    
                    // Xem QR
                    Button {
                        selectedQRForPreview = IdentifiableString(value: item.content)
                    } label: {
                        Label("label_view_qr_code", systemImage: "qrcode")
                    }
                    
                    // Chia sẻ
                    Button {
                        shareContent = IdentifiableString(value: item.content)
                        showShareSheet = true
                    } label: {
                        Label("btn_share", systemImage: "square.and.arrow.up")
                    }
                    
                    // Xoá
                    Button(role: .destructive) {
                        viewModel.deleteByIDs([item.id])
                    } label: {
                        Label("btn_delete", systemImage: "trash")
                    }
                }
            }
            .onDelete(perform: viewModel.deleteItems)
        }
    }
    
    private func displayTitle(for type: QRContentType) -> String {
        switch type {
        case .url: return "🌐 " + NSLocalizedString("title_link", comment: "")
        case .email: return "📧 " + NSLocalizedString("title_email", comment: "")
        case .phone: return "📞 " + NSLocalizedString("title_phone", comment: "")
        case .wifi: return "📶 " + NSLocalizedString("title_wifi", comment: "")
        case .vcard: return "👤 " + NSLocalizedString("title_contact", comment: "")
        case .text: return "📄 " + NSLocalizedString("title_text", comment: "")
        }
    }
    
    private func showWiFiConfig(_ config: String) {
        // Tạm thời alert, sau này có thể custom UI đẹp hơn
        print("WiFi Config: \(config)")
    }
    
    private func addToContacts(vcard: String) {
        let data = vcard.data(using: .utf8)!
        if let contact = try? CNContactVCardSerialization.contacts(with: data).first {
            let controller = CNContactViewController(forNewContact: contact)
            controller.contactStore = CNContactStore()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let windows = windowScene.windows
                // Use windows here
                windows.first?.rootViewController?.presentedViewController?.dismiss(animated: false)
            }
        }
    }
}
