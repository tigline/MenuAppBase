//
//  TabViewContainer.swift
//

import Foundation
import SwiftUI

struct SideBarContainer: View {
    @StateObject private var configuration = AppConfiguration.share
    @State private var loader = ShopMenuInfoLoader()
    @Environment(\.smartwe) var smartwe
    var menus:AnyRandomAccessCollection<MenuState> {
        return AnyRandomAccessCollection(loader)
    }
    
    var body: some View {
        NavigationSplitView {
            SideBar(categorys: menus)
                .navigationSplitViewColumnWidth(200)
                //.navigationSplitViewStyle(.automatic)
        } detail: {
            TabViewContainer(categorys: menus)
        }.onAppear(perform: {
            Task {
                await loader.loadMenuInfo(smartwe: smartwe,shopCode:configuration.shopCode ?? "" ,language:configuration.menuLaguage ?? "")
            }
        })
    }
}

struct SideBar:View {
    
    let categorys:AnyRandomAccessCollection<MenuState>
    
    @Environment(\.store) var store
    @StateObject private var configuration = AppConfiguration.share
    
    var body: some View {
        VStack {
            Image("smartwe.logo")
                .scaledToFit()
            
            
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
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                //.listStyle(SidebarListStyle())
                .navigationBarTitle("Sidebar", displayMode: .inline)
                .navigationBarHidden(true)
                .frame(maxWidth: .infinity, alignment: .leading)
            
                
        }
            Spacer()
            
            Button("Logout"){
                configuration.machineCode = ""
                configuration.loginState = .logout
            }
    }
}



struct TabViewContainer: View {
    @Environment(\.store) var store
    //@Environment(\.store.state.shopMenuState.categorys) var categorys
    var selection: Binding<String> {
        store.binding(for: \.sideSelection, toAction: {
            .sideBarTapped($0)
        })
    }
    let categorys:AnyRandomAccessCollection<MenuState>
    var body: some View {
        TabView(selection: selection) {
            
            ForEach(categorys, id: \.self) { category in
                StackContainer()
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
