//
//  SettingCategory.swift
//

import Foundation
import SwiftUI

enum SettingCategory: Int, CaseIterable, Hashable {
    case appearance
    case genres
    case storage
    case about
    case library

    var localizedString: LocalizedStringKey {
        switch self {
        case .appearance:
            return "SettingCategory_Appearance"
        case .genres:
            return "SettingCategory_Genre"
        case .storage:
            return "SettingCategory_Storage"
        case .about:
            return "SettingCategory_About"
        case .library:
            return "SettingCategory_Library"
        }
    }
}
