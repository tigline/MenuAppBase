//
//  AppLanguage.swift
//

import Foundation
import SwiftUI

enum AppLanguage: Int, CaseIterable, Identifiable {
    case jp
    case en
    case zh
    case ko
    case system

    var localizedString: LocalizedStringKey {
        switch self {
        case .jp:
            return "日本語"
        case .en:
            return "English"
        case .zh:
            return "中文"
        case .ko:
            return "한국"
        case .system:
            return "system"
        }
    }

    var id: Self {
        self
    }
    
    var sourceId: String {
        switch self {
        case .jp:
            return "JP"
        case .en:
            return "EN"
        case .zh:
            return "CH"
        case .system:
            return "JP"
        case .ko:
            return "KO"
        }
    }

    var locale: Locale {
        switch self {
        case .system:
            return .autoupdatingCurrent
        case .zh:
            return .init(identifier: "zh-cn")
        case .en:
            return .init(identifier: "en")
        case .jp:
            return .init(identifier: "ja-JP")
        case .ko:
            return .init(identifier: "ko-KR")
        }
    }
    
    var flag: String {
        switch self {
            
        case .jp:
            return "language_Japanese"
        case .en:
            return "language_English"
        case .zh:
            return "language_Chinese"
        case .ko:
            return "language_Korean"
        case .system:
            return getFaultFlag(local: .autoupdatingCurrent)
        }
    }
    
    func getFaultFlag(local:Locale) -> String {
        if local.identifier.contains("ja") {
            return "language_Japanese"
        } else if local.identifier.contains("zh") {
            return "language_Chinese"
        } else if local.identifier.contains("ko") {
            return "language_Korean"
        } else {
            return "language_English"
        }
    }
}
