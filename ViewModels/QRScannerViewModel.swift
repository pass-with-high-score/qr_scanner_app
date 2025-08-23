//
//  QRScannerViewModel.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/23/25.
//

import Foundation

final class QRScannerViewModel: ObservableObject {
    @Published var history: [QRCodeItem] = []
    
    func addToStory(_ content: String) {
        let item = QRCodeItem(content: content)
        history.insert(item, at: 0)
    }
    
    func clearHistory() {
        history.removeAll()
    }

}

extension QRScannerViewModel {
    static func previewMock() -> QRScannerViewModel {
        let vm = QRScannerViewModel()
        vm.history = [
            QRCodeItem(content: "https://apple.com"),
            QRCodeItem(content: "Text QR example"),
            QRCodeItem(content: "WIFI:S:MyWiFi;T:WPA;P:pass1234;;")
        ]
        return vm
    }
}
