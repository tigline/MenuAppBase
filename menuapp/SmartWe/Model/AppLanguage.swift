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
            return "AppLanguage_Japanese"
        case .en:
            return "AppLanguage_English"
        case .zh:
            return "AppLanguage_Chinese"
        case .system:
            return "Setting_BySystem"
        case .ko:
            return "AppLanguage_Korea"
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
}
