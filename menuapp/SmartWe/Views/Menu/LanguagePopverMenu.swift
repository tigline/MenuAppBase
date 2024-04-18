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
    @State private var maxWidth:CGFloat = 0
    
    var theme:AppTheme {
        configuration.colorScheme
    }
    var body: some View {
            VStack(alignment: .leading) {
                
                ExpandButton(icon: "language_Japanese",
                            text: "日本語",
                            bgColor: configuration.appLanguage == .jp ? theme.themeColor.buttonColor:.clear,
                            textColor: configuration.appLanguage == .jp ? .white:.black) {
                    configuration.appLanguage = .jp
                    showPopover = false
                    Task {
                        let language = configuration.appLanguage
                        await reloadMenuByLan(language.sourceId)
                    }
                    
                }
                    
                ExpandButton(icon: "language_Chinese",
                            text: "中文",
                            bgColor: configuration.appLanguage == .zh ? theme.themeColor.buttonColor:.clear,
                            textColor: configuration.appLanguage == .zh ? .white:.black) {
                    configuration.appLanguage = .zh
                    showPopover = false
                    Task {
                        let language = configuration.appLanguage
                        await reloadMenuByLan(language.sourceId)
                    }
                }
                    
                ExpandButton(icon: "language_English",
                            text: "English",
                            bgColor: configuration.appLanguage == .en ? theme.themeColor.buttonColor:.clear,
                            textColor: configuration.appLanguage == .en ? .white:.black) {
                    configuration.appLanguage = .en
                    showPopover = false
                    Task {
                        let language = configuration.appLanguage
                        await reloadMenuByLan(language.sourceId)
                    }
                }
                ExpandButton(icon: "language_Korean",
                            text: "한국말",
                            bgColor: configuration.appLanguage == .ko ? theme.themeColor.buttonColor:.clear,
                            textColor: configuration.appLanguage == .ko ? .white:.black) {
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
        guard let machineCode = configuration.machineCode else {
            return
        }
        await menuStore.load(shopCode:shopCode, machineCode: machineCode, language:lan)
    }
}

struct MaxWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

//#Preview {
//    LanguagePopverMenu(showPopover: <#Binding<Bool>#>)
//}
