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
    
//    var body: some View {
//        HStack {
//            SideBar()
//                .frame(width: 200)
//                .background(.clear)
//            TabViewContainer()
//        }
//    }
}

struct SideBar:View {
    @Environment(\.store) var store
    var body: some View {
        VStack {
            Image("smartwe.logo")
                .scaledToFit()
            List(Category.showableCategory) { category in
                Button(action: {
                    store.send(.sideBarTapped(category))
                }, label: {
                    HStack {
                        Label(category.localizedString, systemImage: category.iconImage)
                            .foregroundColor(store.state.sideSelection == category ? .white : .blue)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 10, trailing: 0))
                    .background(store.state.sideSelection == category ? Color.blue : Color.clear) // 选中时显示蓝色背景
                    .cornerRadius(10)
                })
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .listStyle(SidebarListStyle())
            .navigationBarTitle("Sidebar", displayMode: .inline)
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        
    }
}



struct TabViewContainer: View {
    @Environment(\.store) var store
    var selection: Binding<Category> {
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
