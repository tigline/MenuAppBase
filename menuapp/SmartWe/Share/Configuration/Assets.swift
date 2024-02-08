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
    let buttonColor:Color// = Color("darkGrey")
    let darkRed:Color// = Color("darkRed")
    let textColor:Color
}

extension Assets {
    var themeColor:ThemeColors {
        switch self {
        case .dark:
            return ThemeColors(mainBackground: Color("darkMain"),
                               buttonColor: Color("darkGrey"),
                               darkRed: Color("darkRed"),
                               textColor: .white)
        case .brown:
            return ThemeColors(mainBackground: Color("darkMain"),
                               buttonColor: Color("darkGrey"),
                               darkRed: Color("darkRed"),
                               textColor: .white)
        case .orange:
            return ThemeColors(mainBackground: Color("darkMain"),
                               buttonColor: Color("darkGrey"),
                               darkRed: Color("darkRed"),
                               textColor: .black)
        }
    }
}
