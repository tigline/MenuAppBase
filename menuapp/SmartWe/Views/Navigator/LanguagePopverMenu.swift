//
//  LanguagePopverMenu.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/09.
//

import SwiftUI

struct LanguagePopverMenu: View {
    @Binding var showPopover:Bool
    @StateObject private var configuration = AppConfiguration.share
    
    var theme:AppTheme {
        configuration.colorScheme
    }
    var body: some View {
            VStack(alignment: .leading) {
                OrderButton(icon: "language_Japanese",
                            text: "日本语") {
                    configuration.appLanguage = .jp
                    showPopover = false
                }
                    
                OrderButton(icon: "language_Chinese",
                            text: "中国语") {
                    configuration.appLanguage = .zh
                    showPopover = false
                }
                    
                OrderButton(icon: "language_English",
                            text: "英语") {
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
