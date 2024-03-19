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
    @Environment(\.menuStore) var menuStore
    
    var theme:AppTheme {
        configuration.colorScheme
    }
    var body: some View {
            VStack(alignment: .leading) {
                OrderButton(icon: "language_Japanese",
                            text: "日本語",
                            bgColor: theme.themeColor.buttonColor,
                            textColor: .white) {
                    configuration.appLanguage = .jp
                    showPopover = false
                    Task {
                        let language = configuration.appLanguage
                        await reloadMenuByLan(language.sourceId)
                    }
                    
                }
                    
                OrderButton(icon: "language_Chinese",
                            text: "中文",
                            bgColor: theme.themeColor.buttonColor,
                            textColor: .white) {
                    configuration.appLanguage = .zh
                    showPopover = false
                    Task {
                        let language = configuration.appLanguage
                        await reloadMenuByLan(language.sourceId)
                    }
                }
                    
                OrderButton(icon: "language_English",
                            text: "English",
                            bgColor: theme.themeColor.buttonColor,
                            textColor: .white) {
                    configuration.appLanguage = .en
                    showPopover = false
                    Task {
                        let language = configuration.appLanguage
                        await reloadMenuByLan(language.sourceId)
                    }
                }
                
                OrderButton(icon: "language_Korea",
                            text: "한국말",
                            bgColor: theme.themeColor.buttonColor,
                            textColor: .white) {
                    configuration.appLanguage = .ko
                    showPopover = false
                    Task {
                        let language = configuration.appLanguage
                        await reloadMenuByLan(language.sourceId)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    
    func reloadMenuByLan(_ lan:String) async {
        guard let shopCode = configuration.shopCode else {
            return
        }
        
        //await menuStore.load(shopCode:shopCode, language:lan)
    }
}

//#Preview {
//    LanguagePopverMenu(showPopover: <#Binding<Bool>#>)
//}
