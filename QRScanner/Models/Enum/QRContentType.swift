//
//  QRContentType.swift
//  QRScanner
//
//  Created by Nguyen Quang Minh on 8/24/25.
//
import Foundation

enum QRContentType {
    case url(URL)
    case email(String)
    case phone(String)
    case wifi(String)
    case vcard(String)
    case text(String)
    
    static func detect(from content: String) -> QRContentType {
        let lower = content.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 1. Check URL (http:// or https://)
        if lower.hasPrefix("http://") || lower.hasPrefix("https://"),
           let url = URL(string: content) {
            return .url(url)
        }
        
        // 2. Check Email (mailto: or @)
        if lower.hasPrefix("mailto:") {
            let email = content.replacingOccurrences(of: "mailto:", with: "")
            return .email(email)
        } else if lower.contains("@") && !lower.contains(" ") {
            return .email(content)
        }
        
        // 3. Check Phone (tel: or số thuần)
        if lower.hasPrefix("tel:") {
            let phone = content.replacingOccurrences(of: "tel:", with: "")
            return .phone(phone)
        } else if lower.allSatisfy({ $0.isNumber || $0 == "+" }) && lower.count >= 7 {
            return .phone(content)
        }
        
        // 4. Check WiFi (WIFI: format chuẩn)
        if lower.hasPrefix("wifi:") {
            return .wifi(content)
        }
        
        // 5. Check vCard
        if lower.hasPrefix("begin:vcard") {
            return .vcard(content)
        }
        
        // Default: Plain text
        return .text(content)
    }
}
