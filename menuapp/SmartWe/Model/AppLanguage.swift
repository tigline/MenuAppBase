//
//  AppLanguage.swift
//

import Foundation
import SwiftUI

enum AppLanguage: Int, CaseIterable, Identifiable {
    case jp
    case en
    case zh
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
        }
    }

    var id: Self {
        self
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
        }
    }
}
