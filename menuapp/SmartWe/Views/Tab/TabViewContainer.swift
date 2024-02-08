//
//  TabViewContainer.swift
//

import Foundation
import SwiftUI

struct SideBarContainer: View {
    @StateObject private var configuration = AppConfiguration.share
    @State private var loader = ShopMenuInfoLoader()
    @Environment(\.smartwe) var smartwe
    @Environment(\.store.state.appTheme) var theme
    var menus:AnyRandomAccessCollection<MenuCategory> {
        return AnyRandomAccessCollection(loader)
    }
    
    var body: some View {
        NavigationSplitView {
            
            SideBar(categorys: menus)
                .navigationSplitViewColumnWidth(200)
                .background(theme.themeColor.mainBackground)
                .navigationSplitViewStyle(.automatic)
            
        } detail: {
            TabViewContainer(categorys: menus)
        }
        
        
        .onAppear(perform: {
            Task {
                await loader.loadMenuInfo(smartwe: smartwe,shopCode:configuration.shopCode ?? "" ,language:configuration.menuLaguage ?? "")
            }
        })
    }
}

struct SideBar:View {
    
    let categorys:AnyRandomAccessCollection<MenuCategory>
    @Environment(\.store.state.appTheme) var theme
    @Environment(\.store) var store
    @StateObject private var configuration = AppConfiguration.share
    
    var body: some View {
        VStack {
            LogoImageView(path: configuration.logoImage)
                .frame(width:200,height: 50)
                .padding(.top,10)
                
                List(categorys) { menu in
                    Button(action: {
                        store.send(.sideBarTapped(menu.categoryName))
                    }, label: {
                        HStack {
                            Label(menu.categoryName, systemImage: "star")
                                .foregroundColor(store.state.sideSelection == menu.categoryName ? .white : .blue)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 15, leading: 10, bottom: 10, trailing: 0))
                        .background(store.state.sideSelection == menu.categoryName ? Color.blue : Color.clear) // 选中时显示蓝色背景
                        .cornerRadius(10)
                    })
                    .background(theme.themeColor.mainBackground)
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                
                .navigationBarTitle("Sidebar", displayMode: .inline)
                .navigationBarHidden(true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(theme.themeColor.mainBackground)
                
            Spacer()
                
        }.background(theme.themeColor.mainBackground)
            
            
//            Button("Logout"){
//                configuration.machineCode = ""
//                configuration.loginState = .logout
//            }.background(theme.themeColor.mainBackground)
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
    let categorys:AnyRandomAccessCollection<MenuCategory>
    
    var body: some View {
        TabView(selection: selection) {
            ForEach(categorys, id: \.self) { category in
                StackContainer(category:category)
                    .tag(category.categoryName)
            }
        }
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
