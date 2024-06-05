//
//  SideBar.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/26.
//

import SwiftUI
struct SideBar:View {
    
    @Environment(MenuStore.self) var menuStore
    @Environment(\.isLoading) private var isLoading
    @EnvironmentObject var configuration: AppConfiguration
    @State var showPopover = false
    @Environment(\.appRouter) var appRouter
    @State private var tapCount = 0
    @State private var lastTapTime = Date()
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
//                .gesture(
//                    LongPressGesture(minimumDuration: 0.5)
//                        .onEnded({ _ in
//                            menuStore.updateTab("setting")
//                            appRouter.updateRouter(.setting)
//                        })
//                )
                .onTapGesture {
                    let now = Date()
                    if now.timeIntervalSince(self.lastTapTime) > 1 {
                        self.tapCount = 0
                    }

                    self.tapCount += 1
                    self.lastTapTime = now
                    print("tapCount = \(tapCount)")
                    if self.tapCount == 7 {
                        self.tapCount = 0
                        menuStore.updateTab("setting")
                        appRouter.updateRouter(.setting)
                        return
                    }

                }

            if isLoading {
                Spacer()
                ProgressView().padding(10)
                    .navigationBarTitle("Sidebar", displayMode: .inline)
                    .navigationBarHidden(true)
            } else {
                sidebarList
            }
                
            Spacer()
                
//            Button(LocalizedStringKey("log_out")){
//                configuration.machineCode = ""
//                configuration.loginState = .logout
//            }
//            .padding()
        }
        
    }
    
    
    
    @ViewBuilder
    var sidebarList: some View {
        List(menuStore.catagorys, id: \.self, selection: selectionBar) { menu in
            
            NavigationLink(value: menu) {
                Text(menu)
                    .padding(.leading, 30)
                    .padding(.vertical)
                    .font(configuration.appLanguage.mediumFont(18))
                    .frame(maxWidth: .infinity, alignment:.leading)
                    .foregroundColor(menuStore.catagory == menu ? theme.themeColor.sideBarTextBg : theme.themeColor.sideBarTextDf)
                    .background(menuStore.catagory == menu ? theme.themeColor.sideBarBtBg : Color.clear)
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

