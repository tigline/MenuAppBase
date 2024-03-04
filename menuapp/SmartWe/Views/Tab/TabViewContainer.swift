//
//  TabViewContainer.swift
//

import Foundation
import SwiftUI

struct SideBarContainer: View {
    @StateObject private var configuration = AppConfiguration.share

    @Environment(\.menuStore) var menuStore
    @Environment(\.cargoStore) var cargoStore
    
    @State var isLoading = false
    @State var showTable = false
    
    @State private var carGoAnimation = false
    @State private var showAddAnimation = false
    @State private var showOptions = false
    @State private var selectItem:UIImage?
    @State private var animationItemFrame = CGRect.zero

    
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
            
            
        }
        .environment(\.goOptions) { menu, image, rect in
            animationItemFrame = rect
            selectItem = image
            
            if let optionGroupVoList =  menu.optionGroupVoList,
                optionGroupVoList.count > 0 {
                menuStore.selectMenuItem(menu)
                showOptions.toggle()
            } else {
                //add to shopping car
                cargoStore.addGood(menu, price: menu.currentPrice)
                showAddAnimation.toggle()
            }
            
        }
        .overlay(
            showOptions ? OptionGroupListView(onAddAtion: { state in
                cargoStore.addGood(state.optionGoodInfo.0,
                                   price: state.optionGoodInfo.1,
                                   options: state.optionGoodInfo.2)
                showAddAnimation.toggle()
            }, isShowing: $showOptions) : nil,
            
            alignment: .center // 定位到底部
        )
        .overlay {
            if showAddAnimation {
                if let animatedItem = selectItem  {
                    GeometryReader { geometry in
                        
                        let originX = animationItemFrame.midX - geometry.frame(in: .global).minX
                        let originY = animationItemFrame.midY - geometry.frame(in: .global).minY
                        let image = Image(uiImage: animatedItem)
                            .clipShape(.circle)
                            .scaleEffect(carGoAnimation ? 0.1:1)
                            
                        image
                            .position(x: originX,
                                      y: originY)
                            .offset(x: carGoAnimation ? (menuStore.cartIconGlobalFrame.midX - originX):0, y: carGoAnimation ? (menuStore.cartIconGlobalFrame.minY-originY):0)
                            
                            .onAppear {
                                withAnimation(.easeInOut) {
                                    carGoAnimation.toggle()
                                    
                                } completion: {
                                    carGoAnimation.toggle()
                                    showAddAnimation.toggle()
                                    selectItem = nil
                                }
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
