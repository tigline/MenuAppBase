//
//  TabViewContainer.swift
//

import Foundation
import SwiftUI
//import CoreData

struct SideBarContainer: View {
    @StateObject private var configuration = AppConfiguration.share

    @Environment(\.menuStore) var menuStore
    @Environment(\.cargoStore) var cargoStore
    //@Environment(\.managedObjectContext) private var context
    
    @State var isLoading = false
    //@State var showTable = false
    
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
//            .onAppear(perform: {
//                Task {
//                    
//                    isLoading = true
//                    guard let shopCode = configuration.shopCode else {
//                        return
//                    }
//                    let language = configuration.appLanguage
//                    await menuStore.load(shopCode:shopCode, language:language.sourceId)
//                    isLoading = false
//                }
//            })
            .onAppear{
                //if configuration.orderKey == nil {
                
                //    showTable = true
                //}
//                NotificationCenter.default.addObserver(
//                    forName: .NSManagedObjectContextObjectsDidChange,
//                    object: self.context,
//                    queue: nil) { notification in
//                        // 处理变化
//                        self.handleContextChange(notification: notification)
//                }
            }
//            .sheet(isPresented: $showTable) {
//                SelectTableView()
//            }
            .onReceive(configuration.$appLanguage){ lan in
                Task {
                    isLoading = true
                    guard let shopCode = configuration.shopCode else {
                        return
                    }
                    await menuStore.load(shopCode:shopCode, language:lan.sourceId)
                    isLoading = false
                }
            }
//            .onDisappear {
//                NotificationCenter.default.removeObserver(self)
//            }
            
            
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
                cargoStore.addGood(menu, price: Int(menu.currentPrice))
                showAddAnimation.toggle()
            }
            
        }
        .overlay(
            showOptions ? OptionGroupListView(model: OptionGroupListView.Model(menu: menuStore.selectMenuItem!), 
                                              isShowing: $showOptions, isShowAdd: $showAddAnimation) : nil,
            
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
    
//    private func handleContextChange(notification: Notification) {
//        if let userInfo = notification.userInfo {
//            if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, !inserts.isEmpty {
//                // 检查是否是你关心的表的变化
//                updateLastChangedDate()
//            }
//            if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, !updates.isEmpty {
//                // 同上
//                updateLastChangedDate()
//            }
//            if let updates = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, !updates.isEmpty {
//                // 同上
//                updateLastChangedDate()
//            }
//        }
//    }
//    
//    func updateLastChangedDate() {
//        let now = Date()
//        UserDefaults.standard.set(now, forKey: "LastChangedDate")
//    }
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
