//
//  SideBar.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/26.
//

import SwiftUI
struct SideBar:View {
    
    @Environment(\.menuStore) var menuStore
    @Environment(\.isLoading) private var isLoading
    @StateObject private var configuration = AppConfiguration.share
    @State var showPopover = false
    @Environment(\.appRouter) var appRouter

    var theme:AppTheme {
        configuration.colorScheme
    }
    
    var selectionBar: Binding<String?> {
        Binding<String?>(
            get: { menuStore.catagory },
            set: {
                menuStore.updateTab($0 ?? "")
                appRouter.updateRouter(.menu($0 ?? ""))
            }
        )
    }
    
    var body: some View {
        let _ = Self._printChanges()

        VStack {
            LogoImageView(path: configuration.logoImage)
                .frame(width:200,height: 50)
                .padding(.top,10)
                .padding(.bottom,30)
                .background(theme.themeColor.mainBackground)
                .gesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .onEnded({ _ in
                            menuStore.updateTab("setting")
                            appRouter.updateRouter(.setting)
                        })
                )
            
            if isLoading {
                Spacer()
                ProgressView().padding(10)
                    .navigationBarTitle("Sidebar", displayMode: .inline)
                    .navigationBarHidden(true)
            } else {
                sidebarList
            }
                
            Spacer()
                
            Button(LocalizedStringKey("log_out")){
                configuration.machineCode = ""
                configuration.loginState = .logout
            }
            .padding()
        }
        
    }
    
    
    
    @ViewBuilder
    var sidebarList: some View {
        List(menuStore.catagorys, id: \.self, selection: selectionBar) { menu in
            
            NavigationLink(value: menu) {
                Label(menu, systemImage: "hand.thumbsup.fill")
                    .padding(.leading)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity, alignment:.leading)
                    .foregroundColor(menuStore.catagory == menu ? .white : .init(hex: "#828282"))
                    .background(menuStore.catagory == menu ? theme.themeColor.buttonColor : Color.clear)
                    .rightHalfRadius(13)
            }
            .listRowBackground(
                Color.clear
            )

        }
        .listStyle(SidebarListStyle())
        .padding(.leading, -25)
        .padding(.trailing, -20)
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, alignment: .leading)
        .scrollContentBackground(.hidden)
    }
}
