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
    @Environment(\.showAlert) var showAlert
    @Environment(\.showTable) var showTable
    
    
    var theme:AppTheme {
        configuration.colorScheme
    }
    
    var tableNo:LocalizedStringKey {
        if configuration.tableNo == nil {
            return LocalizedStringKey("select_a_table")
        }
        
        return LocalizedStringKey("table_no.\(configuration.tableNo ?? "")")
    }
    
    var body: some View {
        HStack{
            
            OrderButton(icon: "button_bell_white",
                        text: "order_button",
                        bgColor: theme.themeColor.orderBtBg,
                        textColor: .white) {
                Task{
                    await menuStore.callWaiter(configuration.machineCode ?? "", configuration.tableNo ?? "", {
                        message in
                        showAlert(message,nil)
                    })
                }
                
            }
        
            OrderButton(icon: menuStore.catagory == "booking_history" ? theme.orderListIconOn: theme.orderListIcon,
                        text: "booking_history",
                        bgColor: menuStore.catagory == "booking_history" ? theme.themeColor.sideBarBtBg : theme.themeColor.toolBarBtBg,
                        textColor: menuStore.catagory == "booking_history" ? theme.themeColor.toolBarTextBgOn : theme.themeColor.toolBarTextBgOff) {
                menuStore.updateTab("booking_history")
                appRouter.updateRouter(.order)
            }
            
            
            CartButton(icon: menuStore.catagory == "shopping_car" ? theme.shoppingCarIconOn:theme.shoppingCarIcon,
                        text: "shopping_car",
                        bgColor: menuStore.catagory == "shopping_car" ? theme.themeColor.sideBarBtBg : theme.themeColor.toolBarBtBg,
                       textColor: menuStore.catagory == "shopping_car" ? theme.themeColor.toolBarTextBgOn : theme.themeColor.toolBarTextBgOff) {
                menuStore.updateTab("shopping_car")
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
//            Button(LocalizedStringKey("setting_theme")){
//    
//                showThemePopover = true
//            }
//            .padding()
//            .frame(height: 44)
//            .foregroundStyle(theme.themeColor.toolBarTextBgOff)
//            .background(theme.themeColor.toolBarBtBg)
//            .cornerRadius(10)
//            .popover(isPresented: $showThemePopover, content: {
//                ThemePopverMenu(showPopover: $showThemePopover)
//            })
            
            OrderButton(icon: "table_icon",
                        text: tableNo,
                        bgColor: theme.themeColor.orderBtBg,
                        textColor: .white) {
                showTable(true)
            }
            

            Button(action: {
                showPopover = true
            }, label: {
                Image(configuration.appLanguage.flag)
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
