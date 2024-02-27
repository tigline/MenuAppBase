//
//  Toolbar.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/26.
//

import SwiftUI


struct ToolbarView: View {
    @Environment(\.store.state.appTheme) var theme
    @StateObject private var configuration = AppConfiguration.share
    @State var showPopover = false
    @State var showThemePopover = false
    @Environment(\.menuStore) var menuStore
    @Environment(\.appRouter) var appRouter
    @Binding var showTable:Bool
    
    var tableNo:String {
        if configuration.tableNo == nil {
            return "Select a table"
        }
        
        return "Table" + " " + configuration.tableNo!
    }
    
    var body: some View {
        HStack{
            
            OrderButton(icon: "button_bell_ White",
                        text: "オーダボタン",
                        bgColor: theme.themeColor.darkRed,
                        textColor: .white) {
                
            }
            OrderButton(icon: "button_ list_black",
                        text: "注文履歴",
                        bgColor: theme.themeColor.mainBackground,
                        textColor: .black) {
                menuStore.updateTab("注文履歴")
                appRouter.updateRouter(.order)
            }
            
            
            CartButton(icon: "button_shopping car_ black",
                        text: "買い物かご",
                        bgColor: menuStore.catagory == "買い物かご" ? theme.themeColor.buttonColor : theme.themeColor.mainBackground,
                        textColor: .black) {
                menuStore.updateTab("買い物かご")
                appRouter.updateRouter(.cart)
                
            }.background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            menuStore.cartIconGlobalFrame = geometry.frame(in: .global)
                        }
                }
            )
            
            Spacer()
//            Button(LocalizedStringKey("setting_theme")){
//    
//                showThemePopover = true
//            }
//            .padding()
//            .background(theme.themeColor.mainBackground)
//            .cornerRadius(10)
//            .popover(isPresented: $showThemePopover, content: {
//                ThemePopverMenu(showPopover: $showThemePopover)
//            })
            
            OrderButton(icon: "button_bell_ White",
                        text: tableNo,
                        bgColor: theme.themeColor.buttonColor,
                        textColor: .white) {
                showTable = true
            }
            
//            OrderButton(icon: "language_Japanese",
//                        text: "日本语",
//                        bgColor: .white,
//                        textColor: .brown) {
//                showPopover = true
//            }
//            .popover(isPresented: $showPopover, content: {
//                LanguagePopverMenu(showPopover: $showPopover)
//            })
            Button(action: {
                showPopover = true
            }, label: {
                Image("language_Japanese")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .shadow(color: .black, radius: 6.0, y:5)
                    
            })
            
            .clipShape(.circle)
            .popover(isPresented: $showPopover, content: {
                LanguagePopverMenu(showPopover: $showPopover)
            })
        

                
        }
        .frame(height: 70)
        .padding(.leading,31)
        .padding(.trailing,16)
        .background(theme.themeColor.navBgColor)
    }
}

//#Preview {
//    ToolbarView()
//}
