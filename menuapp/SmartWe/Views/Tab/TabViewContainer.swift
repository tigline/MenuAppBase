//
//  TabViewContainer.swift
//

import Foundation
import SwiftUI

struct SideBarContainer: View {
    var body: some View {
        NavigationSplitView {
            SideBar()
                .navigationSplitViewColumnWidth(200)
                //.navigationSplitViewStyle(.automatic)
        } detail: {
            TabViewContainer()
        }
    }
}

struct SideBar:View {
    @Environment(\.store) var store
    @StateObject private var configuration = AppConfiguration.share
    @State private var loader = ShopMenuInfoLoader()
    var menus:AnyRandomAccessCollection<MenuCategory> {
        return AnyRandomAccessCollection(loader)
    }
    var body: some View {
        VStack {
            Image("smartwe.logo")
                .scaledToFit()
                
                
                List(menus) { menu in
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
    var selection: Binding<String> {
        store.binding(for: \.sideSelection, toAction: {
            .sideBarTapped($0)
        })
    }

    var body: some View {
        TabView(selection: selection) {
            
            ForEach(Category.showableCategory, id: \.self) { category in
                StackContainer()
                    .tag(category)
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
