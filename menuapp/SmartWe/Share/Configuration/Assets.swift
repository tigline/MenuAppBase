//
//  Asset.swift
//

import Foundation
import SwiftUI

enum AppTheme:Int, CaseIterable, Identifiable {
    
    case orange
    case dark
    case brown
    
    
    enum Colors {
        static let imagePlaceHolder = Color("imagePlaceHolderColor")
        static let rowBackground = Color("rowBackgroundColor")
        static let mainBackground = Color("mainBackground")
        static let favorite = Color("starYellow")
        static let secondWhite = Color("secondWhite")
        static let outline = Color.secondary.opacity(0.3)
        static let windowBackground = Color.secondary.opacity(0.1)
        static let optionDetailColor = Color.init(hex: "#909399")
    }
    
    var id: Self {
        self
    }
}

struct ThemeColors {
    let mainBackground:Color// = Color("darkMain")
    let navBgColor:Color
    let contentBg:Color
    let buttonColor:Color// = Color("darkGrey")
    let orderBtBg:Color// = Color("darkRed")
    let sideBarBtBg:Color
    let cargoLine:Color
    let sideBarTextBg:Color
    let sideBarTextDf:Color
    let quantityBtBg:Color
    let toolBarBtBg:Color
    let toolBarTextBgOn:Color
    let toolBarTextBgOff:Color
    let shortInfoBg:Color
    let shortInfoText:Color
    let addButtonBg:Color
    let cargoTextColor:Color
    let textColor:Color
}

struct CustomFonts {
    static let pingFangSCMedium = Font.custom("PingFangSC-Medium", size: 16)
    static let optionTitle1Font = Font.custom("PingFangSC-Medium", size: 20)
    
    static let optionTitle2Font = Font.custom("PingFangSC-Medium", size: 15)
    
    static let optionButtonFont = Font.custom("PingFangSC-Regular", size: 13)
    
    static let optionDetailFont = Font.custom("PingFangSC-Regular", size: 13)
    
    static let optionOrderFont = Font.custom("PingFangSC-Regular", size: 14)
    
    static let sideBarTextFont = Font.custom("PingFangSC-Regular", size: 17)
    
    static let mentitleFont = Font.custom("PingFangSC-Regular", size: 13)
    
    static let menPriceFont = Font.custom("Avenir-Heavy", size: 15)
    
    static let languageFont = Font.custom("PingFangSC-Semibold", size: 15)
    
    static let carGoMenuFont = Font.custom("PingFangSC-Semibold", size: 18)
    
    static let cargoQuantityFont = Font.custom("Avenir-Heavy", size: 18)
    
    static let cargoCountFont = Font.custom("PingFangSC-Regular", size: 15)
    
    static let cargoTotalFont = Font.custom("PingFangSC-Semibold", size: 20)
    static let cargoTotalPriceFont = Font.custom("Avenir-Heavy", size: 23)
}

extension AppTheme {
    
    var orderListIcon: String {
        switch self {
        
        case .orange:
            return "button_list_black"
        case .dark:
            return "button_list_white"
        case .brown:
            return "button_list_black"
        }
    }
    
    var orderListIconOn: String {
        switch self {
        
        case .orange:
            return "button_list_white"
        case .dark:
            return "button_list_white"
        case .brown:
            return "button_list_black"
        }
    }
    
    var shoppingCarIcon: String {
        switch self {
        
        case .orange:
            return "button_shopping_car_black"
        case .dark:
            return "button_shopping_car_white"
        case .brown:
            return "button_shopping_car_black"
        }
    }
    
    var shoppingCarIconOn: String {
        switch self {
        
        case .orange:
            return "button_shopping_car_white"
        case .dark:
            return "button_shopping_car_white"
        case .brown:
            return "button_shopping_car_black"
        }
    }
    
    var themeColor:ThemeColors {
        switch self {
        case .orange:
            return ThemeColors(mainBackground: .white,
                               navBgColor: .init(hex: "#FFF5EC"),
                               contentBg: .init(hex: "#ECECEC"),
                               buttonColor: .init(hex: "#FC8F36"),
                               orderBtBg: .init(hex: "#FC8F36"),
                               sideBarBtBg: .init(hex: "#FC8F36"),
                               cargoLine: .init(hex: "#5C3C23"),
                               sideBarTextBg: .white,
                               sideBarTextDf: .init(hex:"#828282"),
                               quantityBtBg: .init(hex: "#F8F9FA"),
                               toolBarBtBg: .white,
                               toolBarTextBgOn: .white,
                               toolBarTextBgOff: .black,
                               shortInfoBg: .white, 
                               shortInfoText: .black,
                               addButtonBg: .init(hex: "#FC8F36"),
                               cargoTextColor: .init(red: 92/255, green: 60/255, blue: 35/255),
                               textColor: .black)
        case .dark:
            return ThemeColors(mainBackground: Color("darkMain"),
                               navBgColor: .init(red: 34/255, green: 38/255, blue: 38/255),
                               contentBg: Color("darkGrey"),//.init(red: 34/255, green: 38/255, blue: 38/255),
                               buttonColor: Color("darkMain"),
                               orderBtBg: Color("darkRed"),
                               sideBarBtBg: Color("darkGrey"),
                               cargoLine: .init(red: 129/255, green: 129/255, blue: 129/255),
                               sideBarTextBg: .white, 
                               sideBarTextDf: .white,
                               quantityBtBg: .white,
                               toolBarBtBg: Color("darkMain"),
                               toolBarTextBgOn: .white,
                               toolBarTextBgOff: .white, 
                               shortInfoBg: Color("darkMain"), 
                               shortInfoText: .white,
                               addButtonBg: Color("darkGrey"),
                               cargoTextColor: .white,
                               textColor: .white)
        case .brown:
            return ThemeColors(mainBackground: .init(red: 92/255, green: 60/255, blue: 35/255),
                               navBgColor: .init(red: 254/255, green: 248/255, blue: 244/255),
                               contentBg: .init(red: 239/255, green: 219/255, blue: 204/255),
                               buttonColor: .init(red: 92/255, green: 60/255, blue: 35/255),
                               orderBtBg: Color("darkRed"),
                               sideBarBtBg: .white,
                               cargoLine: .init(hex: "#F7F7F7"),
                               sideBarTextBg: .init(red: 92/255, green: 60/255, blue: 35/255),
                               sideBarTextDf: .white,
                               quantityBtBg: .white,
                               toolBarBtBg: .init(red: 246/255, green: 244/255, blue: 245/255),
                               toolBarTextBgOn: .black,
                               toolBarTextBgOff: .black,
                               shortInfoBg: .white, 
                               shortInfoText: .black, 
                               addButtonBg: .init(red: 92/255, green: 60/255, blue: 35/255),
                               cargoTextColor: .white,
                               textColor: .white)
        
        }
    }
    

    
    var localizedString: LocalizedStringKey {
        switch self {
        case .orange:
            return "orange_text"
        case .dark:
            return "dark_text"
        case .brown:
            return "brown_text"
        
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
