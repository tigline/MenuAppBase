//
//  Asset.swift
//

import Foundation
import SwiftUI

enum Assets {
    
    case dark
    case brown
    case orange
    
    enum Colors {
        static let imagePlaceHolder = Color("imagePlaceHolderColor")
        static let rowBackground = Color("rowBackgroundColor")
        static let mainBackground = Color("mainBackground")
        static let favorite = Color("starYellow")
        static let secondWhite = Color("secondWhite")
        static let outline = Color.secondary.opacity(0.3)
        static let windowBackground = Color.secondary.opacity(0.1)
    }
}

struct ThemeColors {
    let mainBackground:Color// = Color("darkMain")
    let navBgColor:Color
    let contentBg:Color
    let buttonColor:Color// = Color("darkGrey")
    let darkRed:Color// = Color("darkRed")
    let textColor:Color
}

extension Assets {
    var themeColor:ThemeColors {
        switch self {
        case .dark:
            return ThemeColors(mainBackground: Color("darkMain"),
                               navBgColor: Color("darkGrey"),
                               contentBg: Color("darkGrey"),
                               buttonColor: Color("darkGrey"),
                               darkRed: Color("darkRed"),
                               textColor: .white)
        case .brown:
            return ThemeColors(mainBackground: .brown,
                               navBgColor: .white,
                               contentBg: .init(hex: "#FFF5EC"),
                               buttonColor: .brown,
                               darkRed: Color("darkRed"),
                               textColor: .white)
        case .orange:
            return ThemeColors(mainBackground: .white,
                               navBgColor: .init(hex: "#FFF5EC"),
                               contentBg: .init(hex: "#ECECEC"),
                               buttonColor: .init(hex: "#FC8F36"),
                               darkRed: .init(hex: "#FC8F36"),
                               textColor: .black)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}
