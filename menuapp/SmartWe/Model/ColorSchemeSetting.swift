//
//  ColorSchemeSetting.swift
//

import Foundation
import SwiftUI

enum ColorSchemeSetting: Int, CaseIterable, Identifiable {
    case dark
    case light
    case system

    var colorScheme: ColorScheme? {
        switch self {
        case .dark:
            return .dark
        case .light:
            return .light
        case .system:
            return nil
        }
    }

    var localizedString: LocalizedStringKey {
        switch self {
        case .dark:
            return "Setting_DarkMode"
        case .light:
            return "Setting_LightMode"
        case .system:
            return "Setting_BySystem"
        }
    }

    var id: Self {
        self
    }
}

struct ThemeSettings {
    
    let sideBarTheme:SideBarTheme
    
}

struct SideBarTheme {
    let selectedBgColor:Color
    let unSelectedBgColor:Color
    let selectedTextColor:Color
    let unSelectedTextColor:Color
    let selectedIcon:String
    let unSelectedIcon:String
    
    
}
