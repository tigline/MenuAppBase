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
                Button(
                    action: {
                        store.send(.sideBarTapped(category))
                    }, label: {
                        Label(category.localizedString, systemImage: category.iconImage)
                    }
                )
                .foregroundColor(store.state.sideSelection == category ? .primary : .blue)
                //.background(store.state.sideSelection == category ? .primary : .clear)
                .padding(EdgeInsets(top: 15, leading: 0, bottom: 10, trailing: 0))
                .buttonStyle(.plain)
                .cornerRadius(10)
                //.listRowBackground(Color.black)
                
            }
            .background(.clear)
            //.padding(.top, 23)
            .listStyle(SidebarListStyle())
            .navigationBarTitle("Sidebar", displayMode: .inline)
            .navigationBarHidden(true)
            
        }//.background(.black)
        
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
