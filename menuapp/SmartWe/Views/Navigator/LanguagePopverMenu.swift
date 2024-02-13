//
//  LanguagePopverMenu.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/09.
//

import SwiftUI

struct LanguagePopverMenu: View {
    @Binding var showPopover:Bool
    @Environment(\.store.state.appTheme) var theme
    @StateObject private var configuration = AppConfiguration.share
    var body: some View {
            VStack(alignment: .leading) {
                OrderButton(icon: "language_Japanese",
                            text: "日本语",
                            bgColor: theme.themeColor.buttonColor,
                            textColor: .white) {
                    configuration.appLanguage = .jp
                    showPopover = false
                }
                    
                OrderButton(icon: "language_Chinese",
                            text: "中国语",
                            bgColor: theme.themeColor.buttonColor,
                            textColor: .white) {
                    configuration.appLanguage = .zh
                    showPopover = false
                }
                    
                OrderButton(icon: "language_English",
                            text: "英语",
                            bgColor: theme.themeColor.buttonColor,
                            textColor: .white) {
                    configuration.appLanguage = .en
                    showPopover = false
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
}

//#Preview {
//    LanguagePopverMenu(showPopover: <#Binding<Bool>#>)
//}
