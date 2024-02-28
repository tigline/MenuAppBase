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
    
    var color:Color {
        switch self {
        
        case .dark:
            return .black
        case .light:
            return .brown
        case .system:
            return .orange
        }
    }

    var id: Self {
        self
    }
}

struct ThemeSettings {
    
    let sideBarTheme:SideBarTheme
    let addButtonTheme:AddButtonTheme
    let backgroudTheme:BackgroundTheme
    let foodTheme:FoodTheme
}

struct SideBarTheme {
    let selectedBgColor:Color
    let unSelectedBgColor:Color
    let selectedTextColor:Color
    let unSelectedTextColor:Color
    let selectedIcon:String
    let unSelectedIcon:String
}

struct AddButtonTheme {
    let bgColor:Color
}

struct BackgroundTheme {
    let mainBackground:Color
}

struct FoodTheme {
    let titleContainBg:Color
}
