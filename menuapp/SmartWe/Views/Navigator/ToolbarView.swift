//
//  Toolbar.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/26.
//

import SwiftUI


struct ToolbarView: View {

    @StateObject private var configuration = AppConfiguration.share
    @State var showPopover = false
    @State var showThemePopover = false
    @Environment(\.menuStore) var menuStore
    @Environment(\.appRouter) var appRouter
    @Binding var showTable:Bool
    
    var theme:AppTheme {
        configuration.colorScheme
    }
    
    var tableNo:String {
        if configuration.tableNo == nil {
            return "Select a table"
        }
        
        return "Table" + " " + configuration.tableNo!
    }
    
    var body: some View {
        HStack{
            
            OrderButton(icon: "button_bell_white",
                        text: "オーダボタン",
                        bgColor: theme.themeColor.orderBtBg,
                        textColor: .white) {
                
            }
        
            OrderButton(icon: "button_list_white",
                        text: "注文履歴",
                        bgColor: theme.themeColor.toolBarBtBg,
                        textColor: theme.themeColor.toolBarTextBgOff) {
                menuStore.updateTab("注文履歴")
                appRouter.updateRouter(.order)
            }
            
            
            CartButton(icon: "button_shopping_car_white",
                        text: "買い物かご",
                        bgColor: menuStore.catagory == "買い物かご" ? theme.themeColor.sideBarBtBg : theme.themeColor.toolBarBtBg,
                        textColor: theme.themeColor.toolBarTextBgOff) {
                menuStore.updateTab("買い物かご")
                appRouter.updateRouter(.cart)
                
            }
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .task {
                            menuStore.cartIconGlobalFrame = geometry.frame(in: .global)
                        }
                }
            )
            
            Spacer()
            Button(LocalizedStringKey("setting_theme")){
    
                showThemePopover = true
            }
            .padding()
            .frame(height: 44)
            .foregroundStyle(theme.themeColor.toolBarTextBgOff)
            .background(theme.themeColor.toolBarBtBg)
            .cornerRadius(10)
            .popover(isPresented: $showThemePopover, content: {
                ThemePopverMenu(showPopover: $showThemePopover)
            })
            
            OrderButton(icon: "button_bell_white",
                        text: tableNo,
                        bgColor: theme.themeColor.orderBtBg,
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
                    .frame(width: 35, height: 35)
                    
                    
            })
            .frame(width: 40, height: 40)
            .clipShape(.circle)
            .popover(isPresented: $showPopover, content: {
                LanguagePopverMenu(showPopover: $showPopover)
            })
            .buttonStyle(BorderlessButtonStyle())
            .shadow(color: .gray, radius: 1, y:1)
        

                
        }
        .frame(height: 78)
        .padding(.leading,31)
        .padding(.trailing,16)
        .background(theme.themeColor.navBgColor)
    }
}

//#Preview {
//    ToolbarView()
//}
