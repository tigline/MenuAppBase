//
//  TabViewContainer.swift
//

import Foundation
import SwiftUI

struct SideBarContainer: View {
    @StateObject private var configuration = AppConfiguration.share

    @Environment(\.store.state.appTheme) var theme
    @Environment(\.menuStore) var menuStore
    
    @State var isLoading = false
    //@State var selectionBar:String?
    @State var showTable = false
    
    
    var body: some View {
        let _ = Self._printChanges()
        NavigationSplitView {
            
            SideBar()
                .navigationSplitViewColumnWidth(200)
                .background(theme.themeColor.mainBackground)
            
        } detail: {
            StackContainer()
        }
        .environment(\.isLoading, isLoading)
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
        .onAppear{
            if configuration.tableNo == nil {
                showTable = true
            }
        }
        .sheet(isPresented: $showTable) {
            SelectTableView()
        }
    }
}



//struct TabViewContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        #if os(iOS)
////            TabViewContainer()
////                .environmentObject(Store.share)
////                .previewDevice(.iPhoneName)
//
//        SideBarContainer()
//                .environment(\.deviceStatus, .regular)
//                .previewDevice(.iPadName)
//        #endif
//    }
//}
