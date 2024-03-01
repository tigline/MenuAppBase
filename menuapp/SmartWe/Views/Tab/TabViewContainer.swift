//
//  TabViewContainer.swift
//

import Foundation
import SwiftUI

struct SideBarContainer: View {
    @StateObject private var configuration = AppConfiguration.share

    @Environment(\.menuStore) var menuStore
    
    @State var isLoading = false
    //@State var selectionBar:String?
    @State var showTable = false
    
    @State private var carGoAnimation:Bool = false
    @State private var selectItem:UIImage?
    @State private var animationItemFrame = CGRect.zero
    @State private var cartIconFrame = CGRect(x: 500, y: 50, width: 200, height: 54)
    @State private var cornerRadius: CGFloat = 0
    
    var theme:AppTheme {
        configuration.colorScheme
    }
    
    var body: some View {
        let _ = Self._printChanges()
        
        ZStack {
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
            .environment(\.goOptions) { menu, rect in
                animationItemFrame = rect
                selectItem = menu
            }
            
            
        }
        .overlay {
            if let animatedItem = selectItem {
                    GeometryReader { geometry in
                        
                        let originX = animationItemFrame.midX - geometry.frame(in: .global).minX
                        let originY = animationItemFrame.midY - geometry.frame(in: .global).minY
                        let image = Image(uiImage: animatedItem)
                            .clipShape(.circle)
                            .scaleEffect(0.2)
                            
                        image
                                .position(x: originX,
                                          y: originY)
                                .offset(x: carGoAnimation ? (600 - originX):0, y: carGoAnimation ? (50-originY):0)
                                
                                .onAppear {
                                    withAnimation {
                                        carGoAnimation.toggle()
                                        
                                    } completion: {
                                        carGoAnimation.toggle()
                                        selectItem = nil
                                    }
                                }
                    }
                    
                    
                }
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
