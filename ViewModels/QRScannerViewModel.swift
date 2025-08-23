//
//  QRScannerViewModel.swift
//  QR Scan & Save
//
//  Created by Nguyen Quang Minh on 8/23/25.
//

import Foundation

final class QRScannerViewModel: ObservableObject {
    @Published var history: [QRCodeItem] = [] {
        didSet {
            saveToStorage()
        }
    }
    
    private let storageKey = "qr_scan_history"
    
    init() {
        loadFromStorage()
    }
    
    func addToStory(_ content: String) {
        let item = QRCodeItem(content: content)
        history.insert(item, at: 0)
    }
    
    func deleteItems(at offsets: IndexSet) {
        history.remove(atOffsets: offsets)
    }
    
    func clearHistory() {
        history.removeAll()
    }
    
    func deleteByIDs(_ ids: Set<UUID>) {
        history.removeAll { ids.contains($0.id) }
    }

    
    private func saveToStorage() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func loadFromStorage() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let savedHistory = try? JSONDecoder().decode([QRCodeItem].self, from: data) {
            self.history = savedHistory
        }
    }
}
