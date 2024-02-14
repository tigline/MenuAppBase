//
//  TabViewContainer.swift
//

import Foundation
import SwiftUI

struct SideBarContainer: View {
    @StateObject private var configuration = AppConfiguration.share
    @State private var loader = ShopMenuInfoLoader()

    @Environment(\.store.state.appTheme) var theme
    @Environment(\.store.menuStore) var menuStore
    @State var isLoading = false
    
    
    var body: some View {
        let _ = Self._printChanges()
        NavigationSplitView {
            
            SideBar(categorys: menuStore.menuList)
                .navigationSplitViewColumnWidth(200)
                .background(theme.themeColor.mainBackground)
                .navigationSplitViewStyle(.automatic)
                
            
        } detail: {
            TabViewContainer(categorys: menuStore.menuList)
                
        }
        
        
        .onAppear(perform: {
            Task {
                isLoading = true
                guard let shopCode = configuration.shopCode else {
                    return
                }
                guard let language = configuration.menuLaguage else {
                    return
                }
                await menuStore.load(shopCode:shopCode, language:language)
                isLoading = false
            }
        })
    }
}

struct SideBar:View {
    
    let categorys:[MenuCategory]
    @Environment(\.store.state.appTheme) var theme
    @Environment(\.store) var store
    @StateObject private var configuration = AppConfiguration.share
    @State var showPopover = false
    var body: some View {
        let _ = Self._printChanges()

        VStack {
            LogoImageView(path: configuration.logoImage)
                .frame(width:200,height: 50)
                .padding(.top,10)
                .padding(.bottom,30)
            ScrollView(.vertical) {
                ForEach(categorys) { menu in
                    //let menu = index
                    Button(action: {
                        store.send(.sideBarTapped(menu.categoryName))
                    }, label: {
                        HStack {
                            Label(menu.categoryName, systemImage: "hand.thumbsup.fill")
                                .foregroundColor(store.state.sideSelection == menu.categoryName ? .white : .init(hex: "#828282"))
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 15, leading: 30, bottom: 10, trailing: 0))
                        .background(store.state.sideSelection == menu.categoryName ? theme.themeColor.buttonColor : Color.clear)
                        .cornerRadius(10)
                    })
                    .padding(.vertical)
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.trailing, 5)
                .padding(.leading, -10)
                .navigationBarTitle("Sidebar", displayMode: .inline)
                .navigationBarHidden(true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(theme.themeColor.mainBackground)
                
                //                List(categorys) { menu in
                //                    Button(action: {
                //                        store.send(.sideBarTapped(menu.categoryName))
                //                    }, label: {
                //                        HStack {
                //                            Label(menu.categoryName, systemImage: "hand.thumbsup.fill")
                //                                .foregroundColor(store.state.sideSelection == menu.categoryName ? .white : .init(hex: "#828282"))
                //                            Spacer()
                //                        }
                //                        .padding(EdgeInsets(top: 15, leading: 30, bottom: 10, trailing: 0))
                //                        .background(store.state.sideSelection == menu.categoryName ? theme.themeColor.buttonColor : Color.clear)
                //                        .cornerRadius(10)
                //                    })
                //                    //.background(theme.themeColor.mainBackground)
                //                    .buttonStyle(.plain)
                //                    .frame(maxWidth: .infinity, alignment: .leading)
                //
                //                }
                //                .padding(.leading, -32)
                //                .padding(.trailing, -20)
                //                .navigationBarTitle("Sidebar", displayMode: .inline)
                //                .navigationBarHidden(true)
                //                .frame(maxWidth: .infinity, alignment: .leading)
                //                .background(theme.themeColor.mainBackground)
                
                Spacer()
                
                
                
                
            }
            .background(theme.themeColor.mainBackground)
            .scrollIndicators(.hidden)
            
            
            //        Button(LocalizedStringKey("setting_theme")){
            //
            //            showPopover = true
            //        }
            //        .padding()
            //        .background(theme.themeColor.mainBackground)
            //        .popover(isPresented: $showPopover, content: {
            //            ThemePopverMenu(showPopover: $showPopover)
            //        })
            //
            //
            Button(LocalizedStringKey("log_out")){
                configuration.machineCode = ""
                configuration.loginState = .logout
            }
            .padding()
            .background(theme.themeColor.mainBackground)
        }
        
    }
}



struct TabViewContainer: View {
    @Environment(\.store) var store
    @Environment(\.store.state.appTheme) var theme
    var selection: Binding<String> {
        store.binding(for: \.sideSelection, toAction: {
            .sideBarTapped($0)
        })
    }
    let categorys:[MenuCategory]
    
    var body: some View {
        let _ = Self._printChanges()
        ZStack {
            ForEach(categorys, id: \.self) { category in
                if (store.state.sideSelection == category.categoryName) {
                    StackContainer(category:category)
                        .tag(category.categoryName)
                }
                    
            }
        }
        
//        TabView(selection: selection) {
//            ForEach(categorys, id: \.self) { category in
//                StackContainer(category:category)
//                    .tag(category.categoryName)
//            }
//        }
    }
}

struct TabViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        #if os(iOS)
//            TabViewContainer()
//                .environmentObject(Store.share)
//                .previewDevice(.iPhoneName)

        SideBarContainer()
                .environment(\.deviceStatus, .regular)
                .previewDevice(.iPadName)
        #endif
    }
}
