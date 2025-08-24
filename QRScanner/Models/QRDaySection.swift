//
//  QRDaySection.swift
//  QRScanner
//
//  Created by Nguyen Quang Minh on 8/24/25.
//

import Foundation

struct QRDaySection: Identifiable {
    var id: Date { date }
    let date: Date
    var items: [QRCodeItem]
}

