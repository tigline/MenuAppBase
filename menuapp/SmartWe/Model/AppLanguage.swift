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
            return .init(identifier: "ja")
        case .ko:
            return .init(identifier: "ko")
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

extension AppLanguage {
    
    func regularFont(_ size:CGFloat) -> Font {
        switch self {
        case .jp:
            return .custom("HiraginoSans-W3", size: size)
        case .en:
            return .system(size: size)
        case .zh:
            return .custom("PingFangSC-Regular", size: size)
        case .ko:
            return .custom("AppleSDGothicNeo-Regular", size: size)
        case .system:
            return .custom("HiraginoSans-W3", size: size)
        }
    }
    
    func mediumFont(_ size:CGFloat) -> Font {
        switch self {
        case .jp:
            return .custom("HiraginoSans-W5", size: size)
        case .en:
            return .system(size: size, weight: .medium)
        case .zh:
            return .custom("PingFangSC-Medium", size: size)
        case .ko:
            return .custom("AppleSDGothicNeo-Medium", size: size)
        case .system:
            return .custom("HiraginoSans-W5", size: size)
        }
    }
    
    func semiBoldFont(_ size:CGFloat) -> Font {
        switch self {
        case .jp:
            return .custom("HiraginoSans-W5", size: size)
        case .en:
            return .system(size: size, weight: .semibold)
        case .zh:
            return .custom("PingFangSC-SemiBold", size: size)
        case .ko:
            return .custom("AppleSDGothicNeo-SemiBold", size: size)
        case .system:
            return .custom("HiraginoSans-W5", size: size)
        }
    }
    
    func boldFont(_ size:CGFloat) -> Font {
        switch self {
        case .jp:
            return .custom("HiraginoSans-W6", size: size)
        case .en:
            return .system(size: size, weight: .bold)
        case .zh:
            return .custom("PingFangSC-Bold", size: size)
        case .ko:
            return .custom("AppleSDGothicNeo-Bold", size: size)
        case .system:
            return .custom("HiraginoSans-W6", size: size)
        }
    }
    
}

