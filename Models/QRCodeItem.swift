//
//  QRCodeItem.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/23/25.
//

import Foundation

struct QRCodeItem: Identifiable, Codable {
    let id: UUID
    let content: String
    let scannedAt: Date
    
    init(content: String) {
        self.id = UUID()
        self.content = content
        self.scannedAt = Date()
    }
}
