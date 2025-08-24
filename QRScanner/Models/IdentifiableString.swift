//
//  IdentifiableString.swift
//  QRScanner
//
//  Created by Nguyen Quang Minh on 8/24/25.
//

import Foundation

struct IdentifiableString: Identifiable, Equatable {
    var id: String { value }
    let value: String
}

